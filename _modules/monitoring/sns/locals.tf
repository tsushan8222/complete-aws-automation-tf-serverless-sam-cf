locals {
  default_sns_tags = {
    Environment = var.env
    Application = var.sns_topic_name
  }
}
