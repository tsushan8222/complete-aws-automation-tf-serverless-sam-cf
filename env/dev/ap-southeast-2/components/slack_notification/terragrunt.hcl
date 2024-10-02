include {
  path = find_in_parent_folders()
}
terraform {
  source = "${get_parent_terragrunt_dir()}/../_modules/sns/sns_lambda"
}

locals {
  global_environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  regional_vars           = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  sns_topic_name          = "hle-${local.global_environment_vars.locals.environment}-${local.regional_vars.locals.aws_region}-sns-info-logger"
}
inputs = {
  env            = local.global_environment_vars.locals.environment
  sns_topic_name = local.sns_topic_name
  slack_webhook  = "https://hooks.slack.com/s"
  slack_channel  = "devops-messages"
}
