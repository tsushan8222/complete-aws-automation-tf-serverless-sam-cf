include {
  path = find_in_parent_folders()
}
terraform {
  source = "${get_parent_terragrunt_dir()}/../_modules/s3/plain"
}

locals {
  global_environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  regional_vars           = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  bucket_name             = "example-${local.global_environment_vars.locals.environment}-${local.regional_vars.locals.aws_region}-artifact-bucket"
}
inputs = {
  env         = local.global_environment_vars.locals.environment
  bucket_name = local.bucket_name
}
