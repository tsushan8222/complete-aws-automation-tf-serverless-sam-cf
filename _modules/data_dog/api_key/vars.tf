variable "dd_api_key" {
  type        = string
  description = "Datadog API key"
}
variable "dd_api_key_name" {
  type        = string
  description = "Datadog API key name"
  default     = "datadog_api_key"
}

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
