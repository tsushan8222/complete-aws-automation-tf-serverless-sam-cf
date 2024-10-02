output "datadog_iam_role_name" {
  value = var.enable_datadog_aws_integration ? aws_iam_role.datadog_integration[0].name : null
}
output "datadog_iam_role_arn" {
  value = var.enable_datadog_aws_integration ? aws_iam_role.datadog_integration[0].arn : null
}
