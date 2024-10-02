include {
  path = find_in_parent_folders()
}
terraform {
  source = "${get_parent_terragrunt_dir()}/../_modules/cloudformation"
}

locals {
  global_environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  regional_vars           = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  role                    = "fabric-vpc"
}
inputs = {
  env        = local.global_environment_vars.locals.environment
  stack_name = "stack-${local.global_environment_vars.locals.environment}-${local.role}"
  parameters = {
    Environment        = local.global_environment_vars.locals.environment
    VpcCidrBlock16     = "10.0"
    InternalDomain     = "local.net"
    NatEipAllocationId = "-"
    ACMCertificateARN  = "arn:aws:acm:ap-southeast-2:"
  }
  template_body = file("${get_terragrunt_dir()}/template.yml")
}
