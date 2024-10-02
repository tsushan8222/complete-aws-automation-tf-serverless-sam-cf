resource "aws_athena_named_query" "this" {

  count = var.enable_athena_database && var.enable_athena_workgroup && length(var.athena_named_queries) > 0 ? length(var.athena_named_queries) : 0

  workgroup = element(concat(aws_athena_workgroup.this.*.id, [""]), 0)
  database  = element(concat(aws_athena_database.this.*.name, [""]), 0)
  name      = lookup(var.athena_named_queries[count.index], "name", null)
  query     = lookup(var.athena_named_queries[count.index], "query", null)


  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = [
    aws_athena_database.this,
    aws_athena_workgroup.this
  ]
}
