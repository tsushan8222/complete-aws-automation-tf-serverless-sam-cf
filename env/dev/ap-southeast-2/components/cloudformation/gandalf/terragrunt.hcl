include {
  path = find_in_parent_folders()
}
terraform {
  source = "${get_parent_terragrunt_dir()}/../_modules/cloudformation"
}

locals {
  global_environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  regional_vars           = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  role                    = "gandalf-gandalf"
}
inputs = {
  env        = local.global_environment_vars.locals.environment
  stack_name = "stack-${local.global_environment_vars.locals.environment}-${local.role}"
  parameters = {
    Environment       = local.global_environment_vars.locals.environment
    App               = "gandalf"
    Url               = "gandalf"
    InstanceSize      = "t2.small"
    ClusterMin        = "1"
    ClusterMax        = "1"
    Ami               = "ami-0e27b424048853c37"
    ACMCertificateARN = "arn:aws:acm:ap-southeast-2:535662744569:certificate/fbd55fcc-245d-4f68-92c9-49d5d7e56703"
  }
  template_body = file("${get_terragrunt_dir()}/template.yml")
}
