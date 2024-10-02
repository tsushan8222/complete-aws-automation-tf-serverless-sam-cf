locals {
  sns_tags = {
    Name = var.sns_topic_name
    Env  = var.env
  }
}
resource "aws_sns_topic" "this" {
  name = var.sns_topic_name
  tags = merge(local.sns_tags, var.tags)
}

resource "aws_sns_topic_subscription" "this" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "lambda"
  endpoint  = module.sns_target.lambda_function_arn
}
resource "aws_sns_topic_policy" "this" {
  arn    = aws_sns_topic.this.arn
  policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.this.arn]
  }
}

