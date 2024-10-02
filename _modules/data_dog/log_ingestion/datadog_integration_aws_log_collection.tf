# Create a new Datadog - Amazon Web Services integration log collection
resource "datadog_integration_aws_log_collection" "main" {
  account_id = data.aws_caller_identity.current.account_id
  services   = var.sevices_to_ingest_logs_from
}
