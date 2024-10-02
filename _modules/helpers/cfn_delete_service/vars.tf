variable "service_name" {
  type        = string
  default     = "cfn-web-hook-delete-service"
  description = "Service Name"
}

variable "github_shared_secret" {
  type        = string
  description = "Github Shared secret for webhook"
}

variable "env" {
  type        = string
  default     = "dev"
  description = "Environment to which it runs"
}
variable "sns_arn" {
  type        = string
  description = "ARN for SNS to which it sends Build Notifications"
}
