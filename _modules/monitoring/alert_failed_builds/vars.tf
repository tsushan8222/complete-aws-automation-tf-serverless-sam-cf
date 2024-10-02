variable "env" {
  type        = string
  description = "Env to create SNS on"
  default     = "dev"
}
variable "sns_topic_name" {
  type        = string
  description = "SNS topic name"
}
variable "slack_webhook" {
  type        = string
  description = "Slack Webhook endpoint"
}
variable "slack_channel" {
  type        = string
  description = "Slack Channel"
}
variable "tags" {
  type        = map(string)
  description = "SNS Tags"
  default     = {}
}
variable "event_rule_name" {
  type        = string
  description = "AWS CloudWatchEvent Rule name"
  default     = "capture-code-build-state"
}
