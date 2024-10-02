variable "tags" {
  type        = map(string)
  description = "Additional Tags"
  default     = {}
}

variable "namespace" {
  description = "The namespace for grouping resources"
  type        = string
  default     = "monitoring"
}

variable "env" {
  description = "The env tag to apply to all data sent to datadog"
  type        = string
}

# DataDog Core
variable "dd_forwarder_stack_name" {
  description = "DataDog forwarder Stack name"
  type        = string
}

variable "dd_api_secret_manager_arn" {
  description = "Secret manager ARN that has DataDog API key"
  type        = string
}

variable "dd_forwarder_template_version" {
  description = "datadog cloudformation template version"
  type        = string
  default     = "3.40.0"
}
variable "dd_site" {
  description = "Datadog site that your metrics and logs will be sent to"
  type        = string
  default     = "datadoghq.com"
}

# Lambda
variable "dd_forwarder_lambda_function_name" {
  description = "Lambda function name for forwarder"
  type        = string
  default     = "datadog-forwarder"
}
variable "memory_size" {
  description = "Memory size for the Datadog Forwarder Lambda function"
  type        = number
  default     = 1024
}
variable "timeout" {
  description = "Timeout for the Datadog Forwarder Lambda function"
  type        = number
  default     = 120
}
variable "reserved_concurrency" {
  description = "Reserved concurrency for the Datadog Forwarder Lambda function."
  type        = number
  default     = 100
}
variable "log_retention_in_days" {
  description = "Log retention in days for the Datadog Forwarder Lambda"
  type        = number
  default     = 90
}

# Log Forwarding
variable "dd_tags" {
  description = "Add custom tags to forwarded logs, comma-delimited string, no trailing comma, e.g., env:prod,stack:classic"
  type        = string
  default     = ""
}

variable "dd_multiline_log_regex_pattern" {
  description = "Use the supplied regular expression to detect for a new log line for multiline logs from S3, e.g., use expression '\\d{2}\\/\\d{2}\\/\\d{4}' for multiline logs beginning with pattern '11/10/2014'"
  type        = string
  default     = ""
}
variable "dd_use_tcp" {
  description = "By default, the forwarder sends logs using HTTPS through the port 443. To send logs over an SSL encrypted TCP connection, set this parameter to true"
  type        = string
  default     = "false"

}
variable "dd_no_ssl" {
  description = "Disable SSL when forwarding logs, set to true when forwarding logs through a proxy"
  type        = string
  default     = "false"
}
variable "dd_url" {
  description = "The endpoint URL to forward the logs to, useful for forwarding logs through a proxy"
  type        = string
  default     = ""
}
variable "dd_port" {
  description = "The endpoint port to forward the logs to, useful for forwarding logs through a proxy."
  type        = string
  default     = ""
}
variable "dd_skip_ssl_validation" {
  description = "Send logs over HTTPS, while NOT validating the certificate provided by the endpoint. This will still encrypt the traffic between the forwarder and the log intake endpoint, but will not verify if the destination SSL certificate is valid."
  type        = string
  default     = "false"
}
variable "dd_use_compression" {
  description = "Set to false to disable log compression. Only valid when sending logs over HTTP"
  type        = string
  default     = "true"
}
variable "dd_compression_level" {
  description = "Set the compression level from 0 (no compression) to 9 (best compression). The default compression level is 6. You may see some benefit with regard to decreased outbound network traffic if you increase the compression level, at the expense of increased Forwarder execution duration."
  type        = number
  default     = 6
}
variable "dd_forward_log" {
  description = "Set to false to disable log forwarding, while continuing to forward other observability data, such as metrics and traces from Lambda functions."
  type        = string
  default     = "true"
}
variable "dd_fetch_lambda_tags" {
  description = "Let the Forwarder fetch Lambda tags using GetResources API calls and apply them to logs, metrics and traces. If set to true, permission tag:GetResources will be automatically added to the Lambda execution IAM role."
  type        = string
  default     = "true"
}
# Log Scrubbing
variable "redact_ip" {
  description = " Replace text matching \\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3} with xxx.xxx.xxx.xxx"
  type        = string
  default     = "false"
}
variable "redact_email" {
  description = "Replace text matching [a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+ with xxxxx@xxxxx.com"
  type        = string
  default     = "false"
}
variable "dd_scrubbing_rule" {
  description = "Replace text matching the supplied regular expression with xxxxx (default) or DdScrubbingRuleReplacement (if supplied). Log scrubbing rule is applied to the full JSON-formatted log, including any metadata that is automatically added by the Lambda function. Each instance of a pattern match is replaced until no more matches are found in each log. Note, using inefficient regular expression, such as .*, may slow down the Lambda function."
  type        = string
  default     = ""
}
variable "dd_scrubbing_rule_replacement" {
  description = "Replace text matching DdScrubbingRule with the supplied text."
  type        = string
  default     = ""
}

# Log Filtering
variable "exclude_at_match" {
  description = "DO NOT send logs matching the supplied regular expression. If a log matches both the ExcludeAtMatch and IncludeAtMatch, it is excluded."
  type        = string
  default     = ""
}
variable "include_at_match" {
  description = "ONLY send logs matching the supplied regular expression, and not excluded by ExcludeAtMatch.\n Filtering rules are applied to the full JSON-formatted log, including any metadata that is automatically added by the Forwarder. However, transformations applied by log pipelines, which occur after logs are sent to Datadog, cannot be used to filter logs in the Forwarder. Using an inefficient regular expression, such as .*, may slow down the Forwarder."
  type        = string
  default     = ""
}

# Advance configuration
variable "source_zip_url" {
  description = "DO NOT CHANGE unless you know what you are doing. Override the default location of the function source code."
  type        = string
  default     = ""
}
variable "permission_boundary_arn" {
  description = "DO NOT CHANGE unless you know what you are doing"
  type        = string
  default     = ""
}
variable "dd_use_private_link" {
  description = " Set to true to enable sending logs and metrics via AWS PrivateLink. See https://dtdg.co/private-link."
  type        = string
  default     = "false"
}
variable "dd_http_proxy_url" {
  description = " Sets the standard web proxy environment variables HTTP_PROXY and HTTPS_PROXY. These are the url endpoints your proxy server exposes. Don't use this in combination with AWS Private Link. Make sure to also set DdSkipSslValidation to true."
  type        = string
  default     = ""
}
variable "dd_no_proxy" {
  description = "Sets the standard web proxy environment variable NO_PROXY. It is a comma-separated list of domain names that should be excluded from the web proxy."
  type        = string
  default     = ""
}
variable "vpc_security_group_ids" {
  description = "Comma separated list string of VPC Security Group Ids. Used when AWS PrivateLink is enabled."
  type        = string
  default     = ""
}
variable "vpc_subnet_ids" {
  description = "Comma separated list of VPC Subnet Ids. Used when AWS PrivateLink is enabled."
  type        = string
  default     = ""
}
variable "additional_target_lambda_arns" {
  description = "Comma separated list of Lambda ARNs that will get called asynchronously with the same event the Datadog Forwarder receives."
  type        = string
  default     = ""
}
variable "install_as_layer" {
  description = "Whether to use the layer-based installation flow. Set to false to use our legacy installation flow, which installs a second function that copies the forwarder code from GitHub to an S3 bucket. Defaults to true."
  type        = string
  default     = "true"
}
variable "layer_arn" {
  description = "ARN for the layer containing the forwarder code. If empty, the script will use the version of the layer the forwarder was published with."
  type        = string
  default     = ""
}
