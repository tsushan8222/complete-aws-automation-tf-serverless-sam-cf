include {
  path = find_in_parent_folders()
}
terraform {
  source = "${get_parent_terragrunt_dir()}/../_modules/data_dog/api_key"
}

locals {
  global_environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  global_secret_vars      = yamldecode(sops_decrypt_file(find_in_parent_folders("global_secret.${local.global_environment_vars.locals.environment}.yaml")))
}

inputs = {
  env             = local.global_environment_vars.locals.environment
  namespace       = "monitoring"
  dd_api_key      = local.global_secret_vars.DATADOG_API_KEY
  dd_api_key_name = "datadog_api_key"
}
