variable "iam_groups" {
  type        = list(string)
  description = "IAM Group names to create"
}

variable "aws_accounts" {
  type        = list(string)
  description = "list of AWS organization account ID for switch role"
}
