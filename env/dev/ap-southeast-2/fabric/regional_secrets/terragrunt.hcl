include {
  path = find_in_parent_folders()
}
terraform {
  source = "${get_parent_terragrunt_dir()}/../_modules/secrets/secret_manager"
}

locals {
  regional_secret_vars    = yamldecode(sops_decrypt_file(find_in_parent_folders("regional_secret.uat.yaml")))
  global_environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))


  secrets = [
    {
      name = "GITHUB_PACKAGE_TOKEN"
      value = {
        "GITHUB_PACKAGE_TOKEN" = local.regional_secret_vars.GIT_PAT
      }
    }
  ]
}

inputs = {
  env     = local.global_environment_vars.locals.environment
  secrets = local.secrets
}
