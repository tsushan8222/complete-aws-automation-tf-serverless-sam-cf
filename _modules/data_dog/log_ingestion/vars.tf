variable "sevices_to_ingest_logs_from" {
  description = "List of services to collect logs from with forwarder"
  type        = list(string)
  default     = ["lambda"]
}

variable "lambda_forwarder_arn" {
  description = "forwarder ARN for log configuration integration"
  type        = string
}

variable "datadog_api_key" {
  description = "DataDog API key"
  type        = string
}
variable "datadog_app_key" {
  description = "DataDog APP key"
  type        = string
}
