include {
  path = find_in_parent_folders()
}
terraform {
  source = "${get_parent_terragrunt_dir()}/../_modules/monitoring/step_function_logger"
}

locals {
  global_environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  regional_vars           = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  event_rule_name         = "${local.global_environment_vars.locals.environment}enquiry_stepfunction_event_rule"
  application_name        = "${local.global_environment_vars.locals.environment}enquiry_stepfunction_notification"
}
inputs = {
  env                  = local.global_environment_vars.locals.environment
  notification_api     = "https://notification.uat.exmaple.com/api/sendmail"
  application_name     = local.application_name
  event_rule_name      = local.event_rule_name
  internal_group_email = "sushan@sushantiwari.com.np"
  external_group_email = "sushan@sushantiwari.com.np"
  step_function_arns      = ["arn:aws:states:ap-southeast-2:300028123456789266109:stateMachine:simpleMachineuat"]

}
