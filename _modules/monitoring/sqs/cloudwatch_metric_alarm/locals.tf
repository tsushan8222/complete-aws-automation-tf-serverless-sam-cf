locals {
  default_cloudwatch_metric_tags = {
    Environment = var.env
    Application = var.alarm_name
  }
}
