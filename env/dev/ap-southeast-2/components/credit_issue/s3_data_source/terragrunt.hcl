include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../_modules/s3/full"
}

locals {
  global_environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  bucket_name             = "test.${local.global_environment_vars.locals.environment}.exmaple.com"
}

inputs = {
  env         = local.global_environment_vars.locals.environment
  bucket_name = local.bucket_name
}
