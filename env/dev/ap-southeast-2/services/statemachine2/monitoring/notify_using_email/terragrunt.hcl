include {
  path = find_in_parent_folders()
}
terraform {
  source = "${get_parent_terragrunt_dir()}/../_modules/monitoring/sns"
}

locals {
  global_environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  regional_vars           = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  sns_topic_name          = "hle-${local.global_environment_vars.locals.environment}-factfind_queue_alert_topic"
}
inputs = {
  env                                 = local.global_environment_vars.locals.environment
  sns_topic_name                      = local.sns_topic_name
  aws_sns_topic_subscription_protocal = "email"
  aws_sns_topic_subscription_endpoint = "sushan@sushantiwari.com.np"
}
