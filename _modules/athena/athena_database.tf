resource "aws_athena_database" "this" {
  count = var.enable_athena_database && var.athena_database_name != null ? 1 : 0

  name    = lower(replace(var.athena_database_name, "-", "_"))
  bucket  = var.athena_database_bucket_name
  comment = "Athena database: ${var.athena_database_name}"
  dynamic "acl_configuration" {
    iterator = acl_configuration
    for_each = var.athena_acl_configuration

    content {
      s3_acl_option = lookup(acl_configuration, "s3_acl_option", "BUCKET_OWNER_FULL_CONTROL")
    }
  }
  dynamic "encryption_configuration" {
    iterator = encryption_configuration
    for_each = var.athena_encryption_configuration

    content {
      encryption_option = lookup(encryption_configuration, "encryption_option", "SSE_S3")
      kms_key           = lookup(encryption_configuration, "kms_key", null)
    }
  }
  properties    = var.athena_properties
  force_destroy = var.athena_database_force_destroy

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [bucket, encryption_configuration]
  }

  depends_on = [

  ]
}
