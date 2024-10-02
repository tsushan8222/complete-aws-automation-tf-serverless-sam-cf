include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../_modules/data_dog/macro"
}

locals {
  global_environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  regional_vars           = read_terragrunt_config(find_in_parent_folders("region.hcl"))
}

inputs = {
  env              = local.global_environment_vars.locals.environment
  namespace        = "monitoring"
  macro_stack_name = "stack-datadog-macro-${local.global_environment_vars.locals.environment}-${local.regional_vars.locals.aws_region}"
  macro_version    = "0.2.4"
}
