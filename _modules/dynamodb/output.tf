output "dynamodb_arn" {
  value       = module.dynamodb_table.dynamodb_table_arn
  description = "dynamodb ARN"
}