include {
  path = find_in_parent_folders()
}
terraform {
  source = "${get_parent_terragrunt_dir()}/../_modules/monitoring/aws_actions_logger"
}

locals {
  global_environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  regional_vars           = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  sns_topic_name          = "exmaple-${local.global_environment_vars.locals.environment}-${local.regional_vars.locals.aws_region}-aws-action-logger"
}
inputs = {
  env            = local.global_environment_vars.locals.environment
  sns_topic_name = local.sns_topic_name
  slack_webhook  = ""
  slack_channel  = "devops-internal"
}
