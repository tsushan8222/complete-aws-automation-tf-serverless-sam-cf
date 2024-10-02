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
      name  = "SERVICE_BASE_PATH"
      value = var.service_base_path
      type  = "PLAINTEXT"
    },
    {
      name  = "REPORT_GROUP_ARN"
      value = aws_codebuild_report_group.this.arn
      type  = "PLAINTEXT"
    },
    {
      name  = "REPORT_GROUP"
      value = "${var.env}-${var.application_name}"
      type  = "PLAINTEXT"
    }

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
      - apt-get install wget unzip -y
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
      - |
        cat >> /tmp/run.py << 'EOT'
        import os
        import boto3
        from email.mime.multipart import MIMEMultipart
        from email.mime.text import MIMEText
        from email.mime.application import MIMEApplication
        import argparse
        import subprocess
        import sys
        parser = argparse.ArgumentParser()
        parser.add_argument('--recipient', required=True, nargs='+')
        parser.add_argument('--region', required=False, default="us-east-1")
        #parser.add_argument('--report_group', required=True)
        args = parser.parse_args()       
        def create_multipart_message(
                sender: str, recipients: list, title: str, text: str=None, html: str=None, attachments: list=None)\
                -> MIMEMultipart:
            multipart_content_subtype = 'alternative' if text and html else 'mixed'
            msg = MIMEMultipart(multipart_content_subtype)
            msg['Subject'] = title
            msg['From'] = sender
            msg['To'] = ', '.join(recipients)
            if text:
                part = MIMEText(text, 'plain')
                msg.attach(part)
            if html:
                part = MIMEText(html, 'html')
                msg.attach(part)
            for attachment in attachments or []:
                with open(attachment, 'rb') as f:
                    part = MIMEApplication(f.read())
                    part.add_header('Content-Disposition', 'attachment', filename=os.path.basename(attachment))
                    msg.attach(part)
            return msg
        def send_mail(
                sender: str, recipients: list, title: str, text: str=None, html: str=None, attachments: list=None) -> dict:
            msg = create_multipart_message(sender, recipients, title, text, html, attachments)
            ses_client = boto3.client('ses', region_name=args.region)  # Use your settings here
            return ses_client.send_raw_email(
                Source=sender,
                Destinations=recipients,
                RawMessage={'Data': msg.as_string()}
            )
        if __name__ == '__main__':
            sender_ = "devops@homeloanexperts.com.au"
            recipients_ = args.recipient
            CODEBUILD_BUILD_ID = os.environ["CODEBUILD_BUILD_ID"]
            REPORT_GROUP = os.environ["REPORT_GROUP"]
            AWS_ACCOUNT_ID = boto3.client("sts").get_caller_identity()["Account"]
            Session = boto3.session.Session()
            Region = Session.region_name
            title_ = "Unit test Fail on " + CODEBUILD_BUILD_ID
            text_ = 'Code build fail'
            body_ = """<html><head></head>
            <body>
            <h1>Please follow the link for more details. </h1> <br>
            <p>https://""" + Region + """.console.aws.amazon.com/codesuite/codebuild/""" + AWS_ACCOUNT_ID + """/testReports/reportGroups/""" + REPORT_GROUP +"""?region=""" + Region + """ </p> <br> <br>
        
            <h1>Please find the attached Report below:</h1><br>
            </body>"""
            path = os.environ["CODEBUILD_SRC_DIR"]
            SERVICE_BASE_PATH = os.environ["SERVICE_BASE_PATH"]
            resultpath = path + "/" + SERVICE_BASE_PATH + "/infra/unit_test.txt"
            print(resultpath)
            attachments_ = [resultpath]
        
            response_ = send_mail(sender_, recipients_, title_, text_, body_, attachments_)
        EOT
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
      - |
          #!/bin/bash
          set -e

          #Required 
          # 1. ENV
          # 1. DEFAULT_BRANCH
          # 1. CODEBUILD_SOURCE_REPO_URL
          # 1. SERVICE_BASE_PATH

          # Exports
          # 1. DEPLOYMENT_PREFIX
          # 1. CFN_STACK_NAME
          # 1. TERRAFORM_STATE_PATH

          # Overrides
          # 1. DEPLOYMENT_PREFIX

          gen_cfn_compatible_branch_name() {
              name=$1
              # Trimes to len 20
              # Removes (. > - | $ > null | / > - | space > null)
              local special_char_trimed=$(echo $name | sed -E "s/branch\///g" | sed -E "s/refs\/heads\/branch\///g" | sed -E "s/refs\/heads\///g"  | sed -E "s/@//g" | sed -E "s/\//-/g" | sed -E "s/[[:space:]]//g" | sed -E "s/\./-/g" | sed -E "s/$//g" | sed -E "s/_/-/g")
              echo $${special_char_trimed::20}
          }

          gen_cfn_compatible_repo_name() {
              name=$1
              # Trimes to len 20
              # Removes (. > - | $ > null | / > - | space > null)
              local special_char_trimed=$(echo $name | sed "s/git@github.com://g" | sed "s/https:\/\/github.com\///g" | sed "s/\//-/g" | sed "s/.git//g"| sed -E "s/refs\/heads\///g"  | sed -E "s/@//g" | sed -E "s/\//-/g" | sed -E "s/[[:space:]]//g" | sed -E "s/\./-/g" | sed -E "s/$//g" | sed -E "s/_/-/g")
              echo $special_char_trimed
          }
          get_alpha_numeric_char(){
            text=$1
            local stripped=$(echo $text | sed -E "s/[^a-zA-Z0-9]//g")
            echo $stripped
          }

          if [[ -z "$ENV" ]]; then
            echo "Deployment Environment is not set"
            return 1
          fi


          if [[ -z "$DEFAULT_BRANCH" ]]; then
            echo "Default branch is not set for evaluating DEPLOYMENT_PREFIX"
            return 1
          fi

          if [[ -z "$SERVICE_BASE_PATH" ]]; then
            echo "SERVICE_BASE_PATH not set"
            return 1
          fi

          if [[ -z "$CODEBUILD_SOURCE_REPO_URL" ]]; then
            echo "Repo URL not set"
            return 1
          fi

          export REPO_NAME=$(gen_cfn_compatible_repo_name $CODEBUILD_SOURCE_REPO_URL )

          TRIGGER_REF=$DEFAULT_BRANCH

          if [[ -n "$CODEBUILD_WEBHOOK_TRIGGER" ]]; then
            TRIGGER_REF=$(echo $CODEBUILD_WEBHOOK_TRIGGER | sed -E "s/branch\///g" | sed -E "s/refs\/heads\///g" | sed -E "s/refs\/heads\/branch\///g" )
          fi
          # Only For CodeBuild and the code dir shouls be navigated before
          if [[ -z "$CODEBUILD_WEBHOOK_TRIGGER" ]]; then
            git checkout $DEFAULT_BRANCH 
          fi

          PREFIX=''

          if [[ "$TRIGGER_REF" != "$DEFAULT_BRANCH" ]]; then
            PREFIX=$(gen_cfn_compatible_branch_name $CODEBUILD_WEBHOOK_TRIGGER ) 
          fi

          if [[ -z "$DEPLOYMENT_PREFIX" ]]; then
              export DEPLOYMENT_PREFIX=$(echo $PREFIX | awk '{print tolower($0)}')
          else
              export DEPLOYMENT_PREFIX=$(echo $DEPLOYMENT_PREFIX | awk '{print tolower($0)}')
          fi

          SERVICE_BASE_PATH_NORM=$(get_alpha_numeric_char $SERVICE_BASE_PATH)

          CFN_STACK_NAME="$ENV-$REPO_NAME-$SERVICE_BASE_PATH_NORM-$DEPLOYMENT_PREFIX"
          TERRAFORM_STATE_PATH="$ENV/$REPO_NAME/$SERVICE_BASE_PATH_NORM/$DEPLOYMENT_PREFIX"

          if ( [[ -z "$SERVICE_BASE_PATH_NORM" ]] && [[ -n "$DEPLOYMENT_PREFIX" ]]); then
            CFN_STACK_NAME="$ENV-$REPO_NAME-$DEPLOYMENT_PREFIX"
            TERRAFORM_STATE_PATH="$ENV/$REPO_NAME/$DEPLOYMENT_PREFIX"
          fi

          if ( [[ -z "$DEPLOYMENT_PREFIX" ]] && [[ -n "$SERVICE_BASE_PATH_NORM" ]] ); then
            CFN_STACK_NAME="$ENV-$REPO_NAME-$SERVICE_BASE_PATH_NORM"
            TERRAFORM_STATE_PATH="$ENV/$REPO_NAME/$SERVICE_BASE_PATH_NORM"
          fi

          if ( [[ -z "$SERVICE_BASE_PATH_NORM" ]] && [[ -z "$DEPLOYMENT_PREFIX" ]]); then
            CFN_STACK_NAME="$ENV-$REPO_NAME"
            TERRAFORM_STATE_PATH="$ENV/$REPO_NAME"
          fi 

          export CFN_STACK_NAME=$(echo $CFN_STACK_NAME | awk '{print tolower($0)}')
          export TERRAFORM_STATE_PATH=$(echo $TERRAFORM_STATE_PATH | awk '{print tolower($0)}')

          #Logs
          echo $CFN_STACK_NAME
          echo $TERRAFORM_STATE_PATH
      - cd $CODEBUILD_SRC_DIR/$SERVICE_BASE_PATH/infra
      - echo -e "provider \"aws\"{ \n region  = \"$AWS_REGION\" \n version = \"~> 3.2.0\" \n } \n terraform { \n required_version = \"~> 0.14\" \n backend \"s3\" { \n \n } \n } ">backend.tf
      - terraform init -backend-config "bucket=$TERRAFORM_STATE_BUCKET_NAME" -backend-config "region=$AWS_REGION" -backend-config "key=$TERRAFORM_STATE_PATH"
  build:
    commands:
      - terraform plan
    finally:
      - echo "Running Terraform Planning"
  post_build:
    commands:
      - terraform apply -auto-approve
      - echo Build completed on `date`
%{ if var.enable_report == true }
reports:
  $REPORT_GROUP_ARN:
    base-directory: "$CODEBUILD_SRC_DIR/$SERVICE_BASE_PATH/coverage"
    files:
    - 'lcov-report/**/*'
    - 'clover.xml'
    file-format: 'CLOVERXML'
%{ endif }
EOF
  }

  tags = merge(var.tags, local.default_code_build_tags)
}
