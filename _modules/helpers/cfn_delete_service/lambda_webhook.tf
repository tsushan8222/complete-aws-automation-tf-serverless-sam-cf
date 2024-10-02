module "lambda_git_webhook_action" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "3.3.1"

  function_name = var.service_name
  description   = "Web hook action for ${var.service_name}"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"
  timeout       = 600
  publish       = true

  source_path = "./src"

  attach_tracing_policy    = false
  attach_policy_statements = true

  environment_variables = {
    GITHUB_SHARED_SECRET = var.github_shared_secret,
    SNS_ARN              = var.sns_arn
    ENV                  = var.env
  }
  policy_statements = {
    cloudformation = {
      effect    = "Allow",
      actions   = ["cloudformation:*"],
      resources = ["*"]
    },
    s3 = {
      effect    = "Allow",
      actions   = ["s3:*"],
      resources = ["*"]
    },
    all = {
      effect    = "Allow",
      actions   = ["*"],
      resources = ["*"]
    }
  }

  //  create_current_version_allowed_triggers = false
  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${module.git_hub_webhook_api_gateway.apigatewayv2_api_execution_arn}/*/*"
    }
  }
}
