module "git_hub_webhook_api_gateway" {
  source        = "terraform-aws-modules/apigateway-v2/aws"
  version       = "2.0.0"
  name          = var.service_name
  description   = "Webhook gateway for ${var.service_name}"
  protocol_type = "HTTP"

  create_api_domain_name = false

  cors_configuration = {
    allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }


  integrations = {
    "POST /" = {
      lambda_arn             = module.lambda_git_webhook_action.lambda_function_arn
      payload_format_version = "2.0"
      timeout_milliseconds   = 12000
    }

  }
}
