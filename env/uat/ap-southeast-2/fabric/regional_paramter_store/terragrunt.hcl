include {
  path = find_in_parent_folders()
}
terraform {
  source = "${get_parent_terragrunt_dir()}/../_modules/secrets/parameter_store"
}

locals {
  regional_secret_vars    = yamldecode(sops_decrypt_file(find_in_parent_folders("regional_secret.uat.yaml")))
  global_environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))


  parameters = [
    {
      name  = "s_AUTH_KEY"
      type  = "String"
      value = local.regional_secret_vars.s_AUTH_KEY
    }
  ]
}

inputs = {
  env        = local.global_environment_vars.locals.environment
  parameters = local.parameters
}
