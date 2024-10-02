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
      name  = "QA_EXECUTION_COMMAND"
      value = var.qa_execution_command
      type  = "PLAINTEXT"
    },
    {
      name  = "REPORT_PATH"
      value = var.report_path
      type  = "PLAINTEXT"
    },
    {
      name  = "EMAIL_RECIPIENT"
      value = var.email_recipient
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
      - curl -sL https://github.com/shyiko/jabba/raw/master/install.sh | bash
      - . ~/.jabba/jabba.sh && jabba install openjdk@1.16-0
      - apt-get install firefox -y
      - apt-get install firefox-geckodriver -y
      - apt install maven -y
      - npm install -g newman
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
            sender_ = "developers@homeloanexperts.com.au"
            recipients_ = args.recipient
            CODEBUILD_BUILD_ID = os.environ["CODEBUILD_BUILD_ID"]
            title_ = "Regression test report on " + CODEBUILD_BUILD_ID
            text_ = 'Regression test report'
            body_ = """<html><head></head>
            <body>        
            <h1>Please find the attached Report below:</h1><br>
            </body>"""
            path = os.environ["CODEBUILD_SRC_DIR"]
            SERVICE_BASE_PATH = os.environ["SERVICE_BASE_PATH"]
            REPORT_PATH = os.environ["REPORT_PATH"]
            resultpath = path + "/" + SERVICE_BASE_PATH + REPORT_PATH
            print(resultpath)
            attachments_ = [resultpath]
        
            response_ = send_mail(sender_, recipients_, title_, text_, body_, attachments_)
        EOT
    finally:
      - node --version
      - npm --version
      - python --version
      - pip --version
      - java -version
      - mvn -v

  pre_build:
    commands:
      - echo Building Packages for "$CODEBUILD_SOURCE_REPO_URL" on "$CODEBUILD_WEBHOOK_HEAD_REF" branch with build no "$CODEBUILD_BUILD_NUMBER" with commit "$CODEBUILD_RESOLVED_SOURCE_VERSION" triggered by "$CODEBUILD_INITIATOR"
      - echo Build started on `date`
      - npm config set registry https://registry.npmjs.org/
      - npm set @hlexperts:registry=https://npm.pkg.github.com/
      - npm set //npm.pkg.github.com/:_authToken="$GITHUB_PACKAGE_TOKEN"
      - ls -a
      - pwd
      - cd $CODEBUILD_SRC_DIR/$SERVICE_BASE_PATH
      - branch=$(echo $CODEBUILD_WEBHOOK_HEAD_REF | sed "s/refs\/heads\///g" | sed "s/@//g" | sed "s/\//-/g" | sed -E "s/[^(release|hotfix)]+.$//g" | sed "s/hotfix/release/g" | sed "s/[[:space:]]//g" | sed "s/\./-/g" | sed "s/$//g")
      - $QA_EXECUTION_COMMAND || echo "Success"
      - python /tmp/run.py --recipient $EMAIL_RECIPIENT
  #build:
  #  commands:
  #    - terraform plan
  #  finally:
  #    - echo "Running Terraform Planning"
  #post_build:
  #  commands:
  #    - terraform apply -auto-approve
  #    - echo Build completed on `date`
EOF
  }

  tags = merge(var.tags, local.default_code_build_tags)
}
