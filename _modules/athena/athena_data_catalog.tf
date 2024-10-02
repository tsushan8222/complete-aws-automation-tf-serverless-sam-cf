resource "aws_athena_data_catalog" "this" {

  count       = var.enable_athena_catalog && var.athena_catalog_name != null ? 1 : 0
  name        = var.athena_catalog_name
  description = "Glue based Data Catalog: ${var.athena_catalog_name}"
  type        = var.athena_catalog_type

  tags = var.tags

  parameters = {
    function          = lookup(var.athena_catalog_parameters.value, "function", null)
    metadata-function = lookup(var.athena_catalog_parameters.value, "metadata-function", null)
    catalog-id        = lookup(var.athena_catalog_parameters.value, "catalog-id", null)
    record-function   = lookup(var.athena_catalog_parameters.value, "record-function", null)

  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = [

  ]
}
