resource "aws_cloudwatch_event_rule" "cfn_logs" {
  name        = "cfn_logger"
  description = "Logs CloudFormation Events"

  event_pattern = <<EOF
{
  "source": [
    "aws.cloudformation"
  ],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "cloudformation.amazonaws.com"
    ],
    "eventName":[
      "CreateStack",
      "UpdateStack",
      "DeleteStack"
    ]
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.cfn_logs.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.this.arn
}

