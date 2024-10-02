resource "aws_sns_topic_subscription" "this" {
  topic_arn = element(concat(aws_sns_topic.this.*.arn, [""]), 0)
  protocol  = var.aws_sns_topic_subscription_protocal
  endpoint  = var.aws_sns_topic_subscription_endpoint
}

# Resource Based Policy is added from SNS module to remove cyclic dependency
resource "aws_lambda_permission" "with_sns" {
  count         = var.aws_sns_topic_subscription_protocal == "" ? 1 : 0
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = var.aws_sns_topic_subscription_endpoint
  principal     = "sns.amazonaws.com"
  source_arn    = element(concat(aws_sns_topic.this.*.arn, [""]), 0)
}
