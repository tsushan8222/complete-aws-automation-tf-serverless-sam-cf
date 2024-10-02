variable "integration_role_name" {
  type        = string
  description = "Role name for connection between DataDog and AWS"
  default     = "datadog-integration-role"
}
variable "enable_datadog_aws_integration" {
  description = "Use datadog provider to give datadog aws account access to our resources"
  type        = bool
  default     = true
}
variable "account_specific_namespace_rules" {
  description = "account_specific_namespace_rules argument for datadog_integration_aws resource"
  type        = map(any)
  default     = {}
}
variable "excluded_regions" {
  description = "An array of AWS regions to exclude from metrics collection"
  type        = list(string)
  default     = []
}

variable "filter_tags" {
  description = "Array of EC2 tags (in the form key:value) defines a filter that Datadog use when collecting metrics from EC2. Wildcards, such as ? (for single characters) and * (for multiple characters) can also be used. Only hosts that match one of the defined tags will be imported into Datadog. The rest will be ignored."
  type        = list(string)
  default     = []
}
variable "cloudtrail_bucket_name" {
  description = "CloudTrail Bucket name if you want to ingest logs from trail bucket"
  type        = string
  default     = null
}
variable "extra_policy_arns" {
  description = "Extra policy arns to attach to the datadog-integration-role"
  type        = list(string)
  default     = []
}

variable "namespace" {
  description = "The namespace tag to apply to all data sent to datadog"
  type        = string
}

variable "env" {
  description = "The env tag to apply to all data sent to datadog"
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
