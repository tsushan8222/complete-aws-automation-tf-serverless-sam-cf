module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "2.18.0"

  function_name                 = var.application_name
  description                   = "Get execution history of step function based on cloudwatch event and notify"
  handler                       = "index.lambda_handler"
  runtime                       = "python3.8"
  timeout                       = 30
  memory_size                   = 256
  attach_cloudwatch_logs_policy = true

  attach_policy_statements = true
  attach_tracing_policy    = true

  publish = true
  environment_variables = {
    INTERNAL_GROUP_EMAIL = var.internal_group_email
    EXTERNAL_GROUP_EMAIL = var.external_group_email
    NOTIFICATION_API_URL = var.notification_api
    ENV                  = var.env
    EXTERNAL_CC_GROUP_EMAIL = var.external_cc_group_email
  }

  policy_statements = {
    sfn = {
      effect    = "Allow",
      actions   = ["states:*"],
      resources = ["*"]
    }
  }

  source_path = [
    {
      path : "${path.module}/src",
      pip_requirements = "${path.module}/src/requirements.txt",
    }
  ]

  allowed_triggers = {
    CloudWatchTrigger = {
      principal  = "events.amazonaws.com"
      source_arn = aws_cloudwatch_event_rule.this.arn
    }
  }

  tags = merge(var.tags, local.default_lambda_tags)
}
