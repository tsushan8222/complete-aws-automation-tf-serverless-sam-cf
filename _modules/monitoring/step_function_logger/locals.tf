locals {
  default_cloudwatch_event_tags = {
    Environment = var.env
    Application = var.event_rule_name
  }

  default_lambda_tags = {
    Environment = var.env
    Application = var.application_name
  }
}
