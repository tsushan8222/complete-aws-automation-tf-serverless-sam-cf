resource "aws_athena_workgroup" "this" {

  count       = var.enable_athena_database && var.enable_athena_workgroup ? 1 : 0
  name        = var.athena_workgroup_name
  description = "WorkGroup For ${var.athena_database_name}"

  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = true

    result_configuration {
      output_location = "s3://${var.athena_database_bucket_name}/"

      encryption_configuration {
        encryption_option = "SSE_S3"
      }
    }
  }
  tags          = var.tags
  force_destroy = false

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = [
    aws_athena_database.this
  ]
}
