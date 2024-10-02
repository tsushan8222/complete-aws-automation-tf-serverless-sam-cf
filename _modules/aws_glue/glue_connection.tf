#---------------------------------------------------
# AWS Glue connection
#---------------------------------------------------
resource "aws_glue_connection" "glue_connection" {
  count = length(var.aws_glue_connections) > 0 ? length(var.aws_glue_connections) : 0

  name                  = lookup(var.aws_glue_connections[count.index], "glue_connection_name", "${lower(var.name)}-glue-connection-${lower(var.environment)}")
  connection_properties = lookup(var.aws_glue_connections[count.index], "glue_connection_connection_properties", null)

  description     = lookup(var.aws_glue_connections[count.index], "glue_connection_description", null)
  catalog_id      = lookup(var.aws_glue_connections[count.index], "glue_connection_catalog_id", null)
  connection_type = lookup(var.aws_glue_connections[count.index], "glue_connection_connection_type", null) == null ? null : upper(lookup(var.aws_glue_connections[count.index], "glue_connection_connection_type", null))
  match_criteria  = lookup(var.aws_glue_connections[count.index], "glue_connection_match_criteria", null)

  dynamic "physical_connection_requirements" {
    iterator = physical_connection_requirements
    for_each = [lookup(var.aws_glue_connections[count.index], "glue_connection_physical_connection_requirements", [])]

    content {
      availability_zone      = lookup(physical_connection_requirements.value, "availability_zone", null)
      security_group_id_list = lookup(physical_connection_requirements.value, "security_group_id_list", [])
      subnet_id              = lookup(physical_connection_requirements.value, "subnet_id", null)
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = []
}
