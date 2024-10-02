resource "aws_iam_user_policy" "default" {
  name = "default-access-key-policy"
  user = aws_iam_user.user.name
  // default manage own Access Keys
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ManageOwnAccessKeys",
            "Effect": "Allow",
            "Action": [
                "iam:CreateAccessKey",
                "iam:DeleteAccessKey",
                "iam:GetAccessKeyLastUsed",
                "iam:GetUser",
                "iam:ListAccessKeys",
                "iam:UpdateAccessKey",
                "iam:GetAccountPasswordPolicy",
                "iam:ChangePassword",
                "iam:ListMFADevices",
                "iam:CreateVirtualMFADevice",
                "iam:DeleteVirtualMFADevice",
                "iam:EnableMFADevice"
            ],
            "Resource": "*" 
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "this" {
  count      = length(var.managed_policies)
  name       = "${count.index}-attachment"
  users      = [aws_iam_user.user.name]
  policy_arn = var.managed_policies[count.index]
}


resource "aws_iam_user_policy" "this" {
  count  = length(var.policies)
  user   = aws_iam_user.user.name
  policy = data.aws_iam_policy_document.policydoc[count.index].json

}

data "aws_iam_policy_document" "policydoc" {
  count = length(var.policies)
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