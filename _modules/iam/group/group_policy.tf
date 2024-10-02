resource "aws_iam_group_policy" "this" {
  count = length(aws_iam_group.groups)
  name  = "${aws_iam_group.groups[count.index].name}_policy"
  group = aws_iam_group.groups[count.index].name

  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Action" : "sts:AssumeRole",
        "Resource" : [for account in var.aws_accounts : "arn:aws:iam::${account}:role/${aws_iam_group.groups[count.index].name}*"],
        "Condition" : {
          "BoolIfExists" : { "aws:MultiFactorAuthPresent" : "true" }
        }
      }
    ]
  })
}
