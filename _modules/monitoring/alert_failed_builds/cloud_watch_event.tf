resource "aws_cloudwatch_event_rule" "code_build" {
  name        = var.event_rule_name
  description = "Capture Failed and Stopped CodeBuilds"

  event_pattern = <<EOF
{
  "source": [ 
    "aws.codebuild"
  ], 
  "detail-type": [
    "CodeBuild Build State Change"
  ],
  "detail": {
    "build-status": [
      "FAILED",
      "STOPPED" 
    ]
  }  
}
EOF
}

resource "aws_cloudwatch_event_target" "code_build_event_target" {
  rule = aws_cloudwatch_event_rule.code_build.name
  arn  = aws_sns_topic.this.arn
}
