include {
  path = find_in_parent_folders()
}
terraform {
  source = "${get_parent_terragrunt_dir()}/../_modules/helpers/cfn_delete_service"
}

locals {
  global_environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  regional_vars           = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  regional_secret_vars    = yamldecode(sops_decrypt_file(find_in_parent_folders("regional_secret.uat.yaml")))
}

dependencies {
  paths = ["${get_parent_terragrunt_dir()}/${local.global_environment_vars.locals.environment}/${local.regional_vars.locals.aws_region}/components/slack_notification"]
}
dependency "logger_sns_arn" {
  config_path = "${get_parent_terragrunt_dir()}/${local.global_environment_vars.locals.environment}/${local.regional_vars.locals.aws_region}/components/slack_notification"
}
inputs = {
  env                  = local.global_environment_vars.locals.environment
  github_shared_secret = local.regional_secret_vars.GIT_SHARED_SECRET
  sns_arn              = dependency.logger_sns_arn.outputs.sns_arn
}
