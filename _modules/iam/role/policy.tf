data "aws_iam_policy" "this" {
  count = length(var.managed_policies)
  name  = var.managed_policies[count.index]
}

resource "aws_iam_role_policy" "this" {
  count  = var.inline_policy == "" ? 0 : 1
  name   = "additional_policy"
  role   = aws_iam_role.assume_role.id
  policy = var.inline_policy
}
