locals {
  lambda_tags = {
    Name = var.sns_topic_name
    Env  = var.env
  }
}
module "sns_target" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "3.3.1"

  function_name = "${var.sns_topic_name}-target"
  description   = "${var.sns_topic_name}-target"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"

  source_path = [
    {
      path             = "./src",
      pip_requirements = true
    }
  ]
  timeout = 60
  publish = true
  tags    = merge(local.lambda_tags, var.tags)

  allowed_triggers = {
    AllowexecutionFromSNS = {
      service    = "sns"
      source_arn = aws_sns_topic.this.arn
    }
  }
  environment_variables = {
    SLACK_WEBHOOK = var.slack_webhook
    SLACK_CHANNEL = var.slack_channel
  }
}
