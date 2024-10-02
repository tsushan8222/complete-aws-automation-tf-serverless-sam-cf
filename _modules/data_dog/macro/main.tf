resource "aws_cloudformation_stack" "macro" {
  name         = var.macro_stack_name
  capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM", "CAPABILITY_AUTO_EXPAND"]

  template_url = "https://datadog-cloudformation-template.s3.amazonaws.com/aws/serverless-macro/${var.macro_version}.yml"

  tags = merge(var.tags, local.default_tags)

  on_failure = "DELETE"
}
