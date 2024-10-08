#---------------------------------------------------
# AWS Glue crawler
#---------------------------------------------------
resource "aws_glue_crawler" "glue_crawler" {
  count = var.enable_glue_crawler && length(var.glue_crawlers) > 0 ? length(var.glue_crawlers) : 0

  name          = lookup(var.glue_crawlers[count.index], "glue_crawler_name", null) != null ? lower(lookup(var.glue_crawlers[count.index], "glue_crawler_name", null)) : "${lower(var.name)}-glue-crawler-${lower(var.environment)}"
  database_name = lookup(var.glue_crawlers[count.index], "glue_crawler_database_name", null) != null && !var.enable_glue_catalog_database ? lookup(var.glue_crawlers[count.index], "glue_crawler_database_name", null) : element(concat(aws_glue_catalog_database.glue_catalog_database.*.name, [""]), 0)
  role          = lookup(var.glue_crawlers[count.index], "glue_crawler_role", null)

  description            = lookup(var.glue_crawlers[count.index], "glue_crawler_description", null)
  classifiers            = lookup(var.glue_crawlers[count.index], "glue_crawler_classifiers", null)
  configuration          = lookup(var.glue_crawlers[count.index], "glue_crawler_configuration", null)
  schedule               = lookup(var.glue_crawlers[count.index], "glue_crawler_schedule", null)
  security_configuration = lookup(var.glue_crawlers[count.index], "glue_crawler_security_configuration", false) != "" && !var.enable_glue_security_configuration ? lookup(var.glue_crawlers[count.index], "glue_crawler_security_configuration", null) : element(concat(aws_glue_security_configuration.glue_security_configuration.*.id, [""]), 0)
  table_prefix           = lookup(var.glue_crawlers[count.index], "glue_crawler_table_prefix", null)

  dynamic "dynamodb_target" {
    iterator = dynamodb_target
    for_each = lookup(var.glue_crawlers[count.index], "glue_crawler_dynamodb_target", [])

    content {
      path = lookup(dynamodb_target.value, "path", null)
    }
  }

  dynamic "jdbc_target" {
    iterator = jdbc_target
    for_each = lookup(var.glue_crawlers[count.index], "glue_crawler_jdbc_target", [])

    content {
      connection_name = lookup(jdbc_target.value, "connection_name", null)
      path            = lookup(jdbc_target.value, "path", null)
      exclusions      = lookup(jdbc_target.value, "exclusions", null)
    }
  }

  dynamic "s3_target" {
    iterator = s3_target
    for_each = lookup(var.glue_crawlers[count.index], "glue_crawler_s3_target", [])

    content {
      path       = lookup(s3_target.value, "path", null)
      exclusions = lookup(s3_target.value, "exclusions", null)
    }
  }

  dynamic "catalog_target" {
    iterator = catalog_target
    for_each = length(lookup(var.glue_crawlers[count.index], "glue_crawler_catalog_target", [])) > 0 ? [lookup(var.glue_crawlers[count.index], "glue_crawler_catalog_target", [])] : []

    content {
      database_name = lookup(catalog_target.value, "database_name", (var.enable_glue_catalog_database ? element(concat(aws_glue_catalog_database.glue_catalog_database.*.id, [""]), 0) : null))
      tables        = lookup(catalog_target.value, "tables", (var.enable_glue_catalog_table ? element(concat(aws_glue_catalog_table.glue_catalog_table.*.id, [""]), 0) : null))
    }
  }

  dynamic "schema_change_policy" {
    iterator = schema_change_policy
    for_each = lookup(var.glue_crawlers[count.index], "glue_crawler_schema_change_policy", [])

    content {
      delete_behavior = lookup(schema_change_policy.value, "delete_behavior", null)
      update_behavior = lookup(schema_change_policy.value, "update_behavior", null)
    }
  }

  dynamic "mongodb_target" {
    iterator = mongodb_target
    for_each = lookup(var.glue_crawlers[count.index], "glue_crawler_mongodb_target", [])

    content {
      connection_name = lookup(mongodb_target.value, "connection_name", null)

      path     = lookup(mongodb_target.value, "path", null)
      scan_all = lookup(mongodb_target.value, "scan_all", null)
    }
  }

  dynamic "lineage_configuration" {
    iterator = lineage_configuration
    for_each = lookup(var.glue_crawlers[count.index], "glue_crawler_lineage_configuration", [])

    content {
      crawler_lineage_settings = lookup(lineage_configuration.value, "crawler_lineage_settings", null)
    }
  }

  dynamic "recrawl_policy" {
    iterator = recrawl_policy
    for_each = lookup(var.glue_crawlers[count.index], "glue_crawler_recrawl_policy", [])

    content {
      recrawl_behavior = lookup(recrawl_policy.value, "recrawl_behavior", null)
    }
  }

  tags = merge(
    {
      Name = lookup(var.glue_crawlers[count.index], "glue_crawler_name", null) != null ? lower(lookup(var.glue_crawlers[count.index], "glue_crawler_name", null)) : "${lower(var.name)}-glue-crawler-${lower(var.environment)}"
    },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = [
    aws_glue_catalog_database.glue_catalog_database,
    aws_glue_security_configuration.glue_security_configuration,
    aws_glue_catalog_table.glue_catalog_table
  ]
}
