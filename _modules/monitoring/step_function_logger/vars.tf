variable "env" {
  type        = string
  default     = "dev"
  description = "Environment to which it runs"
}
variable "event_rule_name" {
  type        = string
  description = "AWS Cloudwatch Event Rule Name"
}
variable "application_name" {
  type        = string
  description = "Application Name"
}
variable "notification_api" {
  type        = string
  description = "Notification API URL"
}
variable "external_group_email" {
  type        = string
  description = "External Group Email Address"
}
variable "internal_group_email" {
  type        = string
  description = "Internal Group Email Address"
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}

variable "step_function_arns" {
  description = "List of Step Function ARNs to monitor"
  type        = list(string)
  default     = []
}

variable "external_cc_group_email" {
  type        = string
  description = "External CC Email Address"
  default     = ""
}
