locals {
  default_code_build_tags = {
    Environment = var.env
    Application = var.application_name
  }
  default_env_vars = [
    {
      name  = "ARTIFACT_BUCKET_NAME"
      value = var.artifact_bucket_name
      type  = "PLAINTEXT"
    },
    {
      name  = "LOGGING_BUCKET_NAME"
      value = var.logging_bucket_name
      type  = "PLAINTEXT"
    },
    {
      name  = "TERRAFORM_STATE_BUCKET_NAME"
      value = var.tf_state_bucket_name
      type  = "PLAINTEXT"
    },
    {
      name  = "ENV"
      value = var.env
      type  = "PLAINTEXT"
    },
    {
      name  = "DEFAULT_BRANCH"
      value = var.git_branch
      type  = "PLAINTEXT"
    },
    {
      name  = "SERVICES_PATH"
      value = var.services_path
      type  = "PLAINTEXT"
    },
    {
      name  = "DEPLOY_ALL"
      value = var.deploy_all
      type  = "PLAINTEXT"
    },
    {
      name  = "IS_MODE_QUEUED"
      value = var.is_mode_queued
      type  = "PLAINTEXT"
    },
    {
      name  = "SERVICE_MAPPING_CODEBUILD_PROJECT"
      value = var.service_mapping_code_build
      type  = "PLAINTEXT"
    },
  ]
  env_vars = concat(local.default_env_vars, var.env_variables)
}
resource "aws_codebuild_project" "this" {
  # Built in codebuild varaibales
  # https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-env-vars.html
  name          = "${var.env}-${var.application_name}-codebuild"
  description   = "Code Build for ${var.application_name} in ${var.env} "
  build_timeout = var.build_timeout
  service_role  = aws_iam_role.this.arn
  badge_enabled = true

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type = "NO_CACHE"
  }

  environment {
    compute_type                = var.build_compute_size
    image                       = var.build_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    dynamic "environment_variable" {
      for_each = local.env_vars
      content {
        name  = environment_variable.value["name"]
        value = environment_variable.value["value"]
        type  = environment_variable.value["type"]
      }
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "${var.env}-${var.application_name}-logstream"
      stream_name = "build-logs"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${var.logging_bucket_name}/${var.env}/${var.application_name}/buildlog"
    }
  }
  source_version = var.git_branch
  source {
    type                = "GITHUB"
    location            = var.git_repo_url
    git_clone_depth     = 0
    report_build_status = true
    git_submodules_config {
      fetch_submodules = true
    }
    buildspec = <<-EOF
version: 0.2

env:
  shell: bash
  git-credential-helper: yes
  ${length(local.parameter_store_values) > 0 ? "parameter-store:" : ""}
    %{for v_key, v_value in local.parameter_store_values}
    ${v_key}: ${v_value} 
    %{endfor}
  ${length(local.secret_manager_values) > 0 ? "secrets-manager:" : ""}
    %{for v_key, v_value in local.secret_manager_values}
    ${v_key}: ${v_value} 
    %{endfor}
phases:
  install:
    runtime-versions:
      python: "3.7"
      nodejs: "12"
    commands:
      - echo Installing Binaries...
      - curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
      - apt-get update -y
      - apt-get install wget unzip jq -y
      - cd /tmp
      - wget https://releases.hashicorp.com/terraform/0.14.2/terraform_0.14.2_linux_amd64.zip
      - unzip terraform_0.14.2_linux_amd64.zip
      - mv terraform /usr/local/bin/
      - wget https://github.com/gruntwork-io/terragrunt/releases/download/v0.26.7/terragrunt_linux_amd64
      - mv terragrunt_linux_amd64 terragrunt
      - chmod u+x terragrunt
      - mv terragrunt /usr/local/bin/terragrunt
      - npm install -g serverless@2.30.3
      - export SLS_DEBUG=1
      - python3.7 -m pip install aws-sam-cli
      - npm install --global yarn
    finally:
      - node --version
      - npm --version
      - python --version
      - pip --version
      - sam --version
      - serverless --version
      - terraform --version
      - terragrunt --version
      - aws --version
  pre_build:
    commands:
      - echo Building Packages for "$CODEBUILD_SOURCE_REPO_URL" on "$CODEBUILD_WEBHOOK_HEAD_REF" branch with build no "$CODEBUILD_BUILD_NUMBER" with commit "$CODEBUILD_RESOLVED_SOURCE_VERSION" triggered by "$CODEBUILD_INITIATOR"
      - echo Build started on `date`
      - npm config set registry https://registry.npmjs.org/
      - npm set @${var.github_package_org}:registry=https://npm.pkg.github.com/
      - npm set //npm.pkg.github.com/:_authToken="$GITHUB_PACKAGE_TOKEN"
      - cd $CODEBUILD_SRC_DIR
      - git checkout $DEFAULT_BRANCH
      - |
          #!/bin/bash

          set -e

          function elementExists() {
              element=$${1}
              shift
              elements=("$@") 
              in_array=0
              for i in $${elements[@]} ; do
                  if [[ $i == $element ]] ; then
                      in_array=1
                      break
                  fi
              done
              echo $in_array
          }

          function getSubDirAsArray(){
              path=$${1}
              local arr=()
              for dir in $(find $path -maxdepth 1 -type d -exec realpath --relative-to $path {} \;)
              do
                  if [[ ! (($dir == ".") || ($dir == "./") || ($dir == "..")) ]]; then
                      arr=("$${arr[@]}" "$${dir}") 
                  fi
              done 
              echo $${arr[@]} 
          }
          function error_exit()
          {
              echo "$1" 1>&2
              exit 1
          }

          function runCodeBuildWithWait(){
              CODEBUILD_PROJECT_NAME=$1

              echo "Starting CodeBuild project. Project name is $${CODEBUILD_PROJECT_NAME}."

              START_RESULT=`aws codebuild start-build --project-name $${CODEBUILD_PROJECT_NAME}`
              if [ "$?" != "0" ]; then
                  error_exit "Could not start CodeBuild project. Exiting."
              else
                  echo "Build started successfully."
              fi

              BUILD_ID=`echo $${START_RESULT} | jq '.build.id' -r`

              BUILD_STATUS="IN_PROGRESS"
              while [ "$BUILD_STATUS" == "IN_PROGRESS" ]; do
                  sleep 10
                  echo "Checking build status."
                  BUILD=`aws codebuild batch-get-builds --ids $${BUILD_ID}`
                  BUILD_STATUS=`echo $BUILD | jq '.builds[0].buildStatus' -r`
                  if [ "$BUILD_STATUS" == "IN_PROGRESS" ]; then
                      echo "Build is still in progress, waiting..."
                  fi
              done

              if [ "$BUILD_STATUS" != "SUCCEEDED" ]; then
                  LOG_URL=`echo $BUILD | jq '.builds[0].logs.deepLink' -r`
                  error_exit "Build failed, please review job output. Logs are available at $LOG_URL."
              else
                  echo "Build succeeded."
              fi
          }

          function runCodeBuildWithOutWait(){
              CODEBUILD_PROJECT_NAME=$1

              echo "Starting CodeBuild project. Project name is $${CODEBUILD_PROJECT_NAME}."

              START_RESULT=`aws codebuild start-build --project-name $${CODEBUILD_PROJECT_NAME}`
              if [ "$?" != "0" ]; then
                  error_exit "Could not start CodeBuild project. Exiting."
              else
                  echo "Build started successfully."
              fi

              BUILD_ID=`echo $${START_RESULT} | jq '.build.id' -r`

          }
          # check if necessary commands are available
          command -v git > /dev/null 2>&1 || { echo "Git not installed."; exit 1; }
          command -v jq > /dev/null 2>&1 || { echo "jq not installed."; exit 1; }


          # Get Current abbreviated branch name
          branch=`git rev-parse --abbrev-ref HEAD` #set default stage
          echo -e "selected branch $branch"

          # Retrieve the modified files, excluding the merge commit between last two commits
          merge_commit_hash=`git rev-parse --short HEAD`
          build_commit_hash=`git rev-list --no-merges -n1 HEAD`

          files="$(git diff-tree --no-commit-id --name-only -r $build_commit_hash)"
          echo $files

          # Retrive from codebuild
          deploy_all=$${DEPLOY_ALL:-0}
          is_mode_queued=$${IS_MODE_QUEUED:-1}
          common_code_path=$${COMMON_CODE_PATH:-"libs"}
          services_path=$${SERVICES_PATH:-"services"}
          codebuild_with_service_mapping=$${SERVICE_MAPPING_CODEBUILD_PROJECT:-""}
          ####
          echo "Mappings $codebuild_with_service_mapping"
          all_services=()
          changed_services=()

          if [[ -z "$codebuild_with_service_mapping" ]]; then
              exit 1
          fi

          for file in $files; do
              if [[ $file == "$common_code_path"* ]]; then
                  deploy_all=1
                  break
              elif [[ $file == $services_path* ]]; then
                  service_changed="$(echo $file | cut -d '/' -f2)"
                  does_service_exist=$(elementExists $service_changed $${changed_services[@]})
                  if [[ $does_service_exist != 1 ]]; then
                      changed_services=("$${changed_services[@]}" "$service_changed") 
                  fi
              fi
          done

          all_services="$(getSubDirAsArray $services_path)"

          if [[ "$deploy_all" == 1 ]]; then
              changed_services=$${all_services[@]}
          fi
          echo "Changed Sevices $${changed_services[@]}"
          echo "All Sevices $${all_services[@]}"

          services_sorted_by_priority=$(echo $codebuild_with_service_mapping | jq '.services |=(sort_by(.priority) | reverse | unique_by(.service_name))')


          for index in $(jq '.services | keys | .[]' <<< "$services_sorted_by_priority"); do
              value=$(jq -r ".services[$index]" <<< "$services_sorted_by_priority");
              s_name=$(jq -r '.service_name' <<< "$value");
              cb_project_name=$(jq -r '.code_build_project_name' <<< "$value");
              check_if_project=$(elementExists $s_name $${changed_services[@]})
              if [[ $check_if_project == 1 ]]; then
                      if [[ $is_mode_queued == 1 ]]; then
                          echo "Deploying .. $cb_project_name"
                          runCodeBuildWithWait $cb_project_name
                      else
                          echo "Deploying .. $cb_project_name"
                          runCodeBuildWithOutWait $cb_project_name
                      fi
              fi
          done
      - echo "Ran Deployment"
  build:
    commands:
      - echo "Done Deploying"
  post_build:
    commands:
      - echo Build completed on `date`
EOF
  }

  tags = merge(var.tags, local.default_code_build_tags)
}
