locals {
  tags = merge(var.tags, var.iam_tags)
}
resource "aws_iam_role" "this" {
  force_detach_policies = true
  assume_role_policy    = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  tags                  = local.tags
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.policydoc.json
}

data "aws_iam_policy_document" "policydoc" {
  statement {
    actions = [
      "s3:*"
    ]

    resources = [
      "arn:aws:s3:::${var.artifact_bucket_name}",
      "arn:aws:s3:::${var.artifact_bucket_name}/*",
      "arn:aws:s3:::${var.logging_bucket_name}",
      "arn:aws:s3:::${var.logging_bucket_name}/*",
      "arn:aws:s3:::${var.tf_state_bucket_name}",
      "arn:aws:s3:::${var.tf_state_bucket_name}/*"
    ]
  }
  statement {
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild"
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "cloudformation:*",
      "SNS:*",
      "sqs:*",
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs",
      "ec2:CreateNetworkInterfacePermission",
      "codebuild:*"
    ]
    resources = ["*"]
  }
  dynamic "statement" {
    for_each = var.policies
    content {
      sid           = lookup(statement.value, "sid", null)
      effect        = lookup(statement.value, "effect", null)
      actions       = lookup(statement.value, "actions", null)
      not_actions   = lookup(statement.value, "not_actions", null)
      resources     = lookup(statement.value, "resources", null)
      not_resources = lookup(statement.value, "not_resources", null)
      dynamic "principals" {
        for_each = contains(keys(statement.value), "principals") ? statement.value.principals : []
        content {
          type        = lookup(principals.value, "type", null)
          identifiers = lookup(principals.value, "identifiers", null)
        }
      }
      dynamic "not_principals" {
        for_each = contains(keys(statement.value), "not_principals") ? statement.value.principals : []
        content {
          type        = lookup(not_principals.value, "type", null)
          identifiers = lookup(not_principals.value, "identifiers", null)
        }
      }
      dynamic "condition" {
        for_each = contains(keys(statement.value), "condition") ? statement.value.principals : []
        content {
          test     = lookup(condition.value, "type", null)
          variable = lookup(condition.value, "variable", null)
          values   = lookup(condition.value, "values", null)
        }
      }
    }
  }
}
