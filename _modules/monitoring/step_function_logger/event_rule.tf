resource "aws_cloudwatch_event_rule" "this" {
  name        = var.event_rule_name
  description = "Capture Step Functions Execution Status Change"

  tags = merge(var.tags, local.default_cloudwatch_event_tags)

  event_pattern = <<-EOT
{
  "source": ["aws.states"],
  "detail-type": ["Step Functions Execution Status Change"],
  "detail": {
    "status": ["FAILED", "TIMED_OUT", "ABORTED"]
    %{if length(var.step_function_arns) > 0}
    ,
    "stateMachineArn": [
      ${join(", ", [for s in var.step_function_arns : format("%q", s)])}
    ]
    %{endif}
  }
}
EOT
}
