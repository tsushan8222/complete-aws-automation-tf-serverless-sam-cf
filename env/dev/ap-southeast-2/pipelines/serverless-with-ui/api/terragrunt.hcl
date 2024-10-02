
include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["${get_parent_terragrunt_dir()}/${local.global_environment_vars.locals.environment}/${local.regional_vars.locals.aws_region}/components/artifact_bucket", "${get_parent_terragrunt_dir()}/${local.global_environment_vars.locals.environment}/${local.regional_vars.locals.aws_region}/components/logging_bucket", "${get_parent_terragrunt_dir()}/${local.global_environment_vars.locals.environment}/${local.regional_vars.locals.aws_region}/components/slack_notification", "${get_parent_terragrunt_dir()}/${local.global_environment_vars.locals.environment}/${local.regional_vars.locals.aws_region}/components/cfn_delete_webhook_lambda", "${get_parent_terragrunt_dir()}/${local.global_environment_vars.locals.environment}/${local.regional_vars.locals.aws_region}/fabric/regional_secrets"]
}

dependency "artifact_bucket" {
  config_path = "${get_parent_terragrunt_dir()}/${local.global_environment_vars.locals.environment}/${local.regional_vars.locals.aws_region}/components/artifact_bucket"
}
dependency "logging_bucket" {
  config_path = "${get_parent_terragrunt_dir()}/${local.global_environment_vars.locals.environment}/${local.regional_vars.locals.aws_region}/components/logging_bucket"
}
dependency "logger_sns_arn" {
  config_path = "${get_parent_terragrunt_dir()}/${local.global_environment_vars.locals.environment}/${local.regional_vars.locals.aws_region}/components/slack_notification"
}
dependency "cfn_webhook_for_git_delete" {
  config_path = "${get_parent_terragrunt_dir()}/${local.global_environment_vars.locals.environment}/${local.regional_vars.locals.aws_region}/components/cfn_delete_webhook_lambda"
}
dependency "git_packages_token_secret" {
  config_path = "${get_parent_terragrunt_dir()}/${local.global_environment_vars.locals.environment}/${local.regional_vars.locals.aws_region}/fabric/regional_secrets"
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../_modules/pipelines/serverless"
}

locals {
  global_environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  regional_vars           = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  regional_secret_vars    = yamldecode(sops_decrypt_file(find_in_parent_folders("regional_secret.uat.yaml")))
  regional_vars_file      = find_in_parent_folders("common_regional_vars.hcl.json")
  exported_regional_vars  = try(jsondecode(file(local.regional_vars_file)), { "locals" : { "common_vars" : [] } })
  local_env = [
    {
      name  = "DB_NAME"
      value = ""
      type  = "PLAINTEXT"
    },
    {
      name  = "DB_HOST"
      value = "rds.local.net"
      type  = "PLAINTEXT"
    },
    {
      name  = "DB_USER"
      value = ""
      type  = "PLAINTEXT"
    },
    {
      name  = "DB_PORT"
      value = "3306"
      type  = "PLAINTEXT"
    },
    {
      name  = "DB_PASSWORD"
      value = local.regional_secret_vars.HLE_WP_PASSWORD
      type  = "PLAINTEXT"
    },
    {
      name  = "BASE_URL"
      value = ""
      type  = "PLAINTEXT"
    },
    {
      name  = "service1_BASE_URL"
      value = "https://"
      type  = "PLAINTEXT"
    },
    {
      name  = "service_API_KEY"
      value = local.regional_secret_vars.LDAS_API_KEY
      type  = "PLAINTEXT"
    },
    {
      name  = "IP_STACK_ACCESS_KEY"
      value = local.regional_secret_vars.IP_STACK_ACCESS_KEY
      type  = "PLAINTEXT"
    },
    {
      name  = "LQS_UI_BASE_URL"
      value = "https://lqs.uat.homeloanexperts.net.au"
      type  = "PLAINTEXT"
    },
    {
      name  = "NOTIFICATION_API"
      value = "https://notification.uat.exmaple.net.au/api"
      type  = "PLAINTEXT"
    },
    {
      name  = "BCC_RECIPIENT"
      value = ""
      type  = "PLAINTEXT"
    },
    
    {
      name  = "BATCH_SIZE"
      value = 2
      type  = "PLAINTEXT"
    },
    {
      name  = "RESERVE_CONCURRENCY"
      value = 3
      type  = "PLAINTEXT"
    },
    {
      name  = "RECEIVE_MESSAGE_WAIT_TIME"
      value = 20
      type  = "PLAINTEXT"
    },
    {
      name  = "VISIBILITY_TIMEOUT"
      value = 35
      type  = "PLAINTEXT"
    },
    {
      name  = "MAX_RECEIVE_COUNT"
      value = 3
      type  = "PLAINTEXT"
    },
    {
      name  = "DLQ_VISIBILITY_TIMEOUT"
      value = 60
      type  = "PLAINTEXT"
    }
  ]
  common_vars   = local.exported_regional_vars.locals.common_vars
  pipeline_vars = concat(local.local_env, local.common_vars)
  policies = [
    {
      actions   = ["*"]
      resources = ["*"]
    }
  ]
  tags = {
    "name" = "form_api"
  }
}
inputs = {
  tags         = local.tags
  multi_branch = true
  env_variables = concat(
    local.pipeline_vars,
    [
      {
        name  = "GITHUB_PACKAGE_TOKEN"
        value = "${lookup(dependency.git_packages_token_secret.outputs.secret_manager, "GITHUB_PACKAGE_TOKEN")}:GITHUB_PACKAGE_TOKEN"
        type  = "SECRETS_MANAGER"
      }
    ]
  )
  policies             = local.policies
  artifact_bucket_name = dependency.artifact_bucket.outputs.bucket_name
  logging_bucket_name  = dependency.logging_bucket.outputs.bucket_name
  application_name     = "api-servicename"
  env                  = local.global_environment_vars.locals.environment
  git_repo_url         = "https://github.com/"
  git_branch           = "dev-sh"
  github_pat           = local.regional_secret_vars.GIT_PAT
  github_shared_secret = local.regional_secret_vars.GIT_SHARED_SECRET
  sns_arn              = dependency.logger_sns_arn.outputs.sns_arn
  webhook_endpoint     = dependency.cfn_webhook_for_git_delete.outputs.webhook_url
}
