locals {
  default_cf_tags = {
    Environment = var.env
  }
}
resource "aws_cloudformation_stack" "this" {
  name = var.stack_name

  parameters = var.parameters

  template_body = var.template_body

  capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM", "CAPABILITY_AUTO_EXPAND"]
  tags         = merge(var.tags, local.default_cf_tags)

  timeouts {
    create = var.timeout
    delete = var.timeout
    update = var.timeout
  }
}
