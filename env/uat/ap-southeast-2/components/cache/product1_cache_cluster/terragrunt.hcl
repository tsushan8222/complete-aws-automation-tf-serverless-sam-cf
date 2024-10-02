include {
  path = find_in_parent_folders()
}
terraform {
  source = "${get_parent_terragrunt_dir()}/../_modules/elastic_cache/redis"
}

locals {
  global_environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  redis_secrets           = yamldecode(sops_decrypt_file(find_in_parent_folders("redis_secrets.uat.yaml")))
}
inputs = {
  automatic_failover_enabled = true
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  number_cache_clusters      = 1
  replicas_per_node_group    = 1
  num_node_groups            = 1
  node_type                  = "cache.t2.small"
  vpc_id                     = ""
  route_53_hosted_zone_id    = ""
  cluster_name               = ""
  custom_domain_name         = ""
  auth_token                 = local.redis_secrets.REDIS_AUTH_TOKEN
  env                        = local.global_environment_vars.locals.environment
  description                = "cache cluster"
  parameter = [
    {
      name  = "repl-backlog-size"
      value = ""
    }
  ]

}
