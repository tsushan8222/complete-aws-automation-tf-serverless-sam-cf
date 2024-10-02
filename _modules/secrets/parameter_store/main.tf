resource "aws_ssm_parameter" "this" {
  count       = length(var.parameters)
  name        = var.parameters[count.index].name
  type        = var.parameters[count.index].type
  value       = var.parameters[count.index].value
  description = lookup(var.parameters[count.index], "description", "Parameter ${var.parameters[count.index].name}")

  tags = {
    name = var.parameters[count.index].name
    env  = var.env
  }
}