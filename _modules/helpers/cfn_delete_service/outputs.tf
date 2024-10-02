output "webhook_url" {
  value       = module.git_hub_webhook_api_gateway.default_apigatewayv2_stage_invoke_url
  description = "Execution endpoint of APIGW"
}
