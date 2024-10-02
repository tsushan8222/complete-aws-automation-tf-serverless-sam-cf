include {
  path = find_in_parent_folders()
}
terraform {
  source = "${get_parent_terragrunt_dir()}/../_modules/elastic_search_domain"
}

locals {
  global_environment_vars         = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  regional_vars                   = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  env                             = local.global_environment_vars.locals.environment
  es_domain_name                  = "exmaple-elastic-search-niche"
  custom_endpoint                 = ""
  custom_endpoint_certificate_arn = ""
  es_secrets                      = yamldecode(sops_decrypt_file(find_in_parent_folders("elastic_search_secrets.uat.yaml")))
  master_user_name                = local.es_secrets.MASTER_USER_NAME
  master_user_password            = local.es_secrets.MASTER_PASSWORD
  vpc_id                          = ""
  route_53_hosted_zone_id         = ""
}

inputs = {
  env                      = local.global_environment_vars.locals.environment
  domain_name              = local.es_domain_name
  create_service_link_role = true
  vpc_id                   = local.vpc_id
  advanced_security_options = {
    enabled                        = true
    internal_user_database_enabled = true
    master_user_options = {
      master_user_name     = local.master_user_name
      master_user_password = local.master_user_password
    }
  }
  domain_endpoint_options_enforce_https                   = true
  domain_endpoint_options_custom_endpoint_enabled         = true
  domain_endpoint_options_custom_endpoint                 = local.custom_endpoint
  domain_endpoint_options_custom_endpoint_certificate_arn = local.custom_endpoint_certificate_arn
  route_53_hosted_zone_id                                 = local.route_53_hosted_zone_id
  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }
  tags = {
    domain = local.es_domain_name
    env    = local.env
  }
}
