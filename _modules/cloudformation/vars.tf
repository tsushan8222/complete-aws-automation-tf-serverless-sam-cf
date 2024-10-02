variable "env" {
  type        = string
  default     = "dev"
  description = "Environment to which it runs"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional Tags to propagate"
}

variable "stack_name" {
  type        = string
  description = "CloudFormation stack name"
}
variable "parameters" {
  type        = map(string)
  default     = {}
  description = "CloudFormation Parameters Key value"
}
variable "template_body" {
  type        = string
  description = "JSON/YAML string body"
}

variable "timeout" {
  type        = string
  default     = "60m"
  description = "timeout for stack operation"
}
