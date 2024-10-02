include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["${get_parent_terragrunt_dir()}/${local.global_environment_vars.locals.environment}/${local.regional_vars.locals.aws_region}/fabric/integrations/datadog/secret_key"]
}
dependency "dd_api_secret_arn" {
  config_path = "${get_parent_terragrunt_dir()}/${local.global_environment_vars.locals.environment}/${local.regional_vars.locals.aws_region}/fabric/integrations/datadog/secret_key"
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../_modules/data_dog/forwarder"
}

locals {
  global_environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  global_secret_vars      = yamldecode(sops_decrypt_file(find_in_parent_folders("global_secret.${local.global_environment_vars.locals.environment}.yaml")))
  regional_vars           = read_terragrunt_config(find_in_parent_folders("region.hcl"))
}

inputs = {
  env                       = local.global_environment_vars.locals.environment
  namespace                 = "monitoring"
  dd_forwarder_stack_name   = "stack-datadog-forwarder-${local.global_environment_vars.locals.environment}-${local.regional_vars.locals.aws_region}"
  dd_api_secret_manager_arn = dependency.dd_api_secret_arn.outputs.dd_api_key
  dd_tags                   = "env:${local.global_environment_vars.locals.environment},region:${local.regional_vars.locals.aws_region}"
}
