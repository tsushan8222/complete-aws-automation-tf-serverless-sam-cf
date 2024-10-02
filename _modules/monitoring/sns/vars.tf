variable "env" {
  type        = string
  default     = "dev"
  description = "Environment to which it runs"
}
variable "create_sns_topic" {
  description = "Whether to create the SNS topic"
  type        = bool
  default     = true
}
variable "sns_topic_name" {
  description = "The name of the SNS topic to create"
  type        = string
  default     = null
}
variable "aws_sns_topic_subscription_protocal" {
  description = "Protocal Name values can be (application | lambda | sms | sqs | email | email-json | http | https)"
  type        = string
  # validation {
  #   condition     = can(regex("application|lambda|sms|sqs|email|email-json|http|https", var.aws_sns_topic_subscription_protocal))
  #   error_message = "ERROR: Invalid protocal can be only of type application|lambda|sms|sqs|email|email-json|http|https"
  # }
}
variable "aws_sns_topic_subscription_endpoint" {
  description = "Subscription endpoint can be (ARN | EMAIL | http | https)"
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "SNS Tags"
  default     = {}
}
