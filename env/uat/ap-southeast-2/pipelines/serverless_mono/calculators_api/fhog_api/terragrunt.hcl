
include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["${get_parent_terragrunt_dir()}/${local.global_environment_vars.locals.environment}/${local.regional_vars.locals.aws_region}/components/artifact_bucket", "${get_parent_terragrunt_dir()}/${local.global_environment_vars.locals.environment}/${local.regional_vars.locals.aws_region}/components/logging_bucket", "${get_parent_terragrunt_dir()}/${local.global_environment_vars.locals.environment}/${local.regional_vars.locals.aws_region}/components/slack_notification", "${get_parent_terragrunt_dir()}/${local.global_environment_vars.locals.environment}/${local.regional_vars.locals.aws_region}/fabric/regional_secrets"]
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
dependency "git_packages_token_secret" {
  config_path = "${get_parent_terragrunt_dir()}/${local.global_environment_vars.locals.environment}/${local.regional_vars.locals.aws_region}/fabric/regional_secrets"
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../_modules/pipelines/serverless_mono"
}

locals {
  global_environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  regional_vars           = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  regional_secret_vars    = yamldecode(sops_decrypt_file(find_in_parent_folders("regional_secret.uat.yaml")))
  regional_vars_file      = find_in_parent_folders("common_regional_vars.hcl.json")
  exported_regional_vars  = try(jsondecode(file(local.regional_vars_file)), { "locals" : { "common_vars" : [] } })
  local_env = [

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
    "name" = "serverless_mono2"
  }
}
inputs = {
  tags = local.tags
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
  application_name     = "serverless_mono2"
  env                  = local.global_environment_vars.locals.environment
  git_repo_url         = "https://github.com/hlexperts/"
  git_branch           = "test-1.0"
  github_pat           = local.regional_secret_vars.GIT_PAT
  github_shared_secret = local.regional_secret_vars.GIT_SHARED_SECRET
  sns_arn              = dependency.logger_sns_arn.outputs.sns_arn
  service_base_path    = "services/folder_name"
  common_trigger_path  = "libs"
}
