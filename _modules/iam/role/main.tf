resource "aws_iam_role" "assume_role" {
  name               = var.assume_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "managed_policies" {
  count      = length(var.managed_policies)
  role       = aws_iam_role.assume_role.name
  policy_arn = data.aws_iam_policy.this[count.index].arn
}