output "sns_arn" {
  value       = aws_sns_topic.this.arn
  description = "SNS ARN endpoint"
}
