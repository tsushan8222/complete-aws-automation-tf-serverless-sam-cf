output "bucket_name" {
  value       = module.s3.s3_bucket_id
  description = "S3 bucket name"
}
output "bucket_arn" {
  value       = module.s3.s3_bucket_arn
  description = "S3 bucket ARN"
}
