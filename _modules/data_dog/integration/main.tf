## This tf file will setup Datadog AWS integration
# https://docs.datadoghq.com/integrations/faq/aws-integration-with-terraform/

resource "datadog_integration_aws" "core" {
  count      = var.enable_datadog_aws_integration ? 1 : 0
  account_id = data.aws_caller_identity.current.account_id
  role_name  = var.integration_role_name

  host_tags = [
    "Namespace:${var.namespace}",
    "env:${var.env}"
  ]

  account_specific_namespace_rules = var.account_specific_namespace_rules
  excluded_regions                 = var.excluded_regions
  filter_tags                      = var.filter_tags
}

resource "aws_iam_role" "datadog_integration" {
  count = var.enable_datadog_aws_integration ? 1 : 0
  name  = var.integration_role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::464622532012:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "${datadog_integration_aws.core[0].external_id}"
        }
      }
    }
  ]
}
EOF

  tags = merge(local.default_tags, {
    description = "This role allows the datadog AWS account to access this account for metrics collection"
  })
}

resource "aws_iam_policy" "datadog_core" {
  count       = var.enable_datadog_aws_integration ? 1 : 0
  name        = "datadog-core-integration"
  path        = "/"
  description = "This IAM policy allows for core datadog integration permissions"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "apigateway:GET",
        "autoscaling:Describe*",
        "budgets:ViewBudget",
        "cloudformation:DetectStack*",
        "cloudfront:GetDistributionConfig",
        "cloudfront:ListDistributions",
        "cloudtrail:LookupEvents",
        "cloudtrail:DescribeTrails",
        "cloudtrail:GetTrailStatus",
        "cloudwatch:Describe*",
        "cloudwatch:Get*",
        "cloudwatch:List*",
        "codedeploy:List*",
        "codedeploy:BatchGet*",
        "directconnect:Describe*",
        "dynamodb:List*",
        "dynamodb:Describe*",
        "ec2:Describe*",
        "ecs:Describe*",
        "ecs:List*",
        "elasticache:Describe*",
        "elasticache:List*",
        "elasticfilesystem:DescribeAccessPoints",
        "elasticfilesystem:DescribeFileSystems",
        "elasticfilesystem:DescribeTags",
        "elasticloadbalancing:Describe*",
        "elasticmapreduce:List*",
        "elasticmapreduce:Describe*",
        "es:ListTags",
        "es:ListDomainNames",
        "es:DescribeElasticsearchDomains",
        "fsx:DescribeFileSystems",
        "health:DescribeEvents",
        "health:DescribeEventDetails",
        "health:DescribeAffectedEntities",
        "kinesis:List*",
        "kinesis:Describe*",
        "lambda:AddPermission",
        "lambda:GetPolicy",
        "lambda:List*",
        "lambda:RemovePermission",
        "logs:Get*",
        "logs:Describe*",
        "logs:FilterLogEvents",
        "logs:TestMetricFilter",
        "logs:PutSubscriptionFilter",
        "logs:DeleteSubscriptionFilter",
        "logs:DescribeSubscriptionFilters",
        "organizations:DescribeOrganization",
        "rds:Describe*",
        "rds:List*",
        "redshift:DescribeClusters",
        "redshift:DescribeLoggingStatus",
        "route53:List*",
        "s3:GetBucketLogging",
        "s3:GetBucketLocation",
        "s3:GetBucketNotification",
        "s3:GetBucketTagging",
        "s3:ListAllMyBuckets",
        "s3:PutBucketNotification",
        "ses:Get*",
        "sns:List*",
        "sns:Publish",
        "states:ListStateMachines",
        "states:DescribeStateMachine",
        "sqs:ListQueues",
        "support:*",
        "tag:GetResources",
        "tag:GetTagKeys",
        "tag:GetTagValues",
        "xray:BatchGetTraces",
        "xray:GetTraceSummaries"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "datadog_core_attach" {
  count      = var.enable_datadog_aws_integration ? 1 : 0
  role       = aws_iam_role.datadog_integration[0].name
  policy_arn = aws_iam_policy.datadog_core[0].arn
}

resource "aws_iam_role_policy_attachment" "datadog_core_attach_extras" {
  for_each   = toset(var.extra_policy_arns)
  role       = aws_iam_role.datadog_integration[0].name
  policy_arn = each.value
}

data "aws_iam_policy_document" "policydoc" {
  statement {
    actions = [
      "s3:ListBucket", "s3:GetBucketLocation", "s3:GetObject", "s3:ListObjects"
    ]
    resources = [
      "arn:aws:s3:::${var.cloudtrail_bucket_name != null ? var.cloudtrail_bucket_name : "null"}",
      "arn:aws:s3:::${var.cloudtrail_bucket_name != null ? var.cloudtrail_bucket_name : "null"}/*"
    ]
  }
}
resource "aws_iam_policy" "cloudtrail_access_policy" {
  name   = "datadog-extra_policy_for_cloudtrail"
  path   = "/"
  policy = data.aws_iam_policy_document.policydoc.json
}
resource "aws_iam_role_policy_attachment" "datadog_core_attach_cloudtrail_policy" {
  count      = var.cloudtrail_bucket_name != null ? 1 : 0
  role       = aws_iam_role.datadog_integration[0].name
  policy_arn = aws_iam_policy.cloudtrail_access_policy.arn
}
