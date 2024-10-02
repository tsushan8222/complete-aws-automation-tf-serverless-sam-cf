include {
  path = find_in_parent_folders()
}
terraform {
  source = "${get_parent_terragrunt_dir()}/../_modules/iam/user"
}

dependencies {
  paths = ["${get_parent_terragrunt_dir()}/${local.global_environment_vars.locals.environment}/${local.regional_vars.locals.aws_region}/group"]
}

locals {
  global_environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  regional_vars           = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  policies = [
    
  ]
}

inputs = {
    iam_groups = ["devops"]
    region = local.regional_vars.locals.aws_region
    username = "sushantest@example.com"
    policies = local.policies
    managed_policies = []
    sender_email = "developers@example.com"
    keybase_pgp_key = "devopshle"
}