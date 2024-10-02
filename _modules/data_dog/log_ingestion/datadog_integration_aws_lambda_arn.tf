# Create a new Datadog - Amazon Web Services integration Lambda ARN
# Update operations are currently not supported with datadog API so any change forces a new resource.

resource "datadog_integration_aws_lambda_arn" "main_collector" {
  account_id = data.aws_caller_identity.current.account_id
  lambda_arn = var.lambda_forwarder_arn
}
