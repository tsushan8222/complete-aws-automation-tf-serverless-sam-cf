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

variable "macro_stack_name" {
  description = "DataDog Macro Stack name"
  type        = string
}

variable "macro_version" {
  description = "Macro version to be deployed"
  type        = string
  default     = "0.2.4"
}
