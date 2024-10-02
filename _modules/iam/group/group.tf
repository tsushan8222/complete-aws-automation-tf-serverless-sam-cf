resource "aws_iam_group" "groups" {
  count = length(var.iam_groups)
  name  = var.iam_groups[count.index]
  path  = "/users/"
}