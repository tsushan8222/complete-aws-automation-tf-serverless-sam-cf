# Read Only ESHTTP Get
resource "aws_iam_role" "read_only" {
  force_detach_policies = true
  assume_role_policy    = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
resource "aws_iam_role_policy" "es_read_only_policy" {
  role   = aws_iam_role.read_only.id
  policy = data.aws_iam_policy_document.es_read_only_policy_doc.json
}

data "aws_iam_policy_document" "es_read_only_policy_doc" {
  statement {
    actions = [
      "es:ESHttpGet"
    ]

    resources = [
      join("", aws_elasticsearch_domain.es_domain.*.arn),
      "${join("", aws_elasticsearch_domain.es_domain.*.arn)}/*"
    ]
  }
}


# Full Access Http

resource "aws_iam_role" "es_http_full_access" {
  force_detach_policies = true
  assume_role_policy    = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
resource "aws_iam_role_policy" "es_http_full_access_policy" {
  role   = aws_iam_role.es_http_full_access.id
  policy = data.aws_iam_policy_document.es_http_full_access_policy_doc.json
}

data "aws_iam_policy_document" "es_http_full_access_policy_doc" {
  statement {
    actions = [
      "es:ESHttp*"
    ]

    resources = [
      join("", aws_elasticsearch_domain.es_domain.*.arn),
      "${join("", aws_elasticsearch_domain.es_domain.*.arn)}/*"
    ]
  }
}

# Full cluster role
resource "aws_iam_role" "es_full_access" {
  force_detach_policies = true
  assume_role_policy    = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
resource "aws_iam_role_policy" "es_full_access_policy" {
  role   = aws_iam_role.es_full_access.id
  policy = data.aws_iam_policy_document.es_full_access_policy_doc.json
}

data "aws_iam_policy_document" "es_full_access_policy_doc" {
  statement {
    actions = [
      "es:*"
    ]

    resources = [
      join("", aws_elasticsearch_domain.es_domain.*.arn),
      "${join("", aws_elasticsearch_domain.es_domain.*.arn)}/*"
    ]
  }
}
