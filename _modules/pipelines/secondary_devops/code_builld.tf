locals {
  default_code_build_tags = {
    Environment = var.env
    Application = var.application_name
  }
  default_env_vars = [
    {
      name  = "ENV"
      value = var.env
      type  = "PLAINTEXT"
    },
    {
      name  = "DEFAULT_BRANCH"
      value = var.git_branch
      type  = "PLAINTEXT"
    }
  ]
  env_vars = concat(local.default_env_vars, var.env_variables)
}
resource "aws_codebuild_project" "this" {
  # Built in codebuild varaibales
  # https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-env-vars.html
  name                   = "${var.env}-${var.application_name}-codebuild"
  description            = "Code Build for ${var.application_name} in ${var.env} "
  build_timeout          = var.build_timeout
  service_role           = aws_iam_role.this.arn
  badge_enabled          = true
  concurrent_build_limit = var.concurrent_build_limit

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
  secondary_sources {
    type              = "GITHUB"
    git_clone_depth   = 0
    location          = var.devops_git_url
    source_identifier = "devops"
    git_submodules_config {
      fetch_submodules = true
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
      nodejs: "12"
      python: "3.9"
    commands:
      - echo Installing Binaries...
      - curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
      - apt-get update -y
      - pip install --upgrade --user boto3
      - pip install python-magic
    finally:
      - node --version
      - npm --version
      - python --version
      - pip --version
      - aws --version
      - sam --version
  pre_build:
    on-failure: ABORT
    commands:
      - echo Building Packages for "$CODEBUILD_SOURCE_REPO_URL" on "$CODEBUILD_WEBHOOK_HEAD_REF" branch with build no "$CODEBUILD_BUILD_NUMBER" with commit "$CODEBUILD_RESOLVED_SOURCE_VERSION" triggered by "$CODEBUILD_INITIATOR"
      - echo Build started on `date`
      - echo configuring npm registery
      - npm config set registry https://registry.npmjs.org/
      - npm set @${var.github_package_org}:registry=https://npm.pkg.github.com/
      - npm set //npm.pkg.github.com/:_authToken="$GITHUB_PACKAGE_TOKEN"
      - cd $CODEBUILD_SRC_DIR_devops
      - git checkout ${var.devops_branch}
      - cd $CODEBUILD_SRC_DIR
      - export DEFAULT_BRANCH="${var.git_branch}"
      - branch=$(echo $CODEBUILD_WEBHOOK_HEAD_REF | sed "s/refs\/heads\///g" | sed "s/@//g" | sed "s/\//-/g" | sed "s/[[:space:]]//g" | sed "s/\./-/g" | sed "s/$//g")
      - if [[ -z $branch ]] ; then git checkout $DEFAULT_BRANCH ; else echo $branch ; fi
      - $CODEBUILD_SRC_DIR_devops/deploy/aws-package.py -e ${var.env} -r ${var.application_role} -p $CODEBUILD_SRC_DIR/${var.dist_path} -s $CODEBUILD_SRC_DIR/${var.build_script_path} -v
      - echo "Packaging Done"
  build:
    on-failure: ABORT
    commands:
      - echo "Deploying"
      - $CODEBUILD_SRC_DIR_devops/deploy/aws-go.py -e ${var.env} -r ${var.application_role} -v
  post_build:
    on-failure: ABORT
    commands:
      - echo Build completed on `date`
EOF
  }

  tags = merge(var.tags, local.default_code_build_tags)
}
