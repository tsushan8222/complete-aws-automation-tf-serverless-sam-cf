# Module      : Iam Role
# Description : Terraform module to create IAm role resource on AWS.
resource "aws_iam_role" "default" {
  count                 = var.enabled ? 1 : 0
  name                  = var.iam_role_name
  assume_role_policy    = var.assume_role_policy
  managed_policy_arns   = var.managed_policy_arns
  force_detach_policies = var.force_detach_policies
  path                  = var.path
  description           = var.description
  max_session_duration  = var.max_session_duration
  permissions_boundary  = var.permissions_boundary
  tags                  = var.tags
}

# Module      : Iam Role Policy
# Description : Terraform module to create IAm role policy resource on AWS to attach with Iam Role.
resource "aws_iam_role_policy" "default" {
  count  = var.enabled && var.policy_enabled && var.policy_arn == "" ? 1 : 0
  name   = format("%s-policy", var.iam_role_name)
  role   = aws_iam_role.default.*.id[0]
  policy = var.policy
}

# Module      : Iam Role Policy
# Description : Terraform module to create IAm role policy resource on AWS to attach with Iam Role.
resource "aws_iam_role_policy_attachment" "default" {
  count = var.enabled && var.policy_enabled && var.policy_arn != "" ? 1 : 0
  role  = aws_iam_role.default.*.id[0]

  policy_arn = var.policy_arn
}
