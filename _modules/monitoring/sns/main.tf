resource "aws_sns_topic" "this" {
  count = var.create_sns_topic ? 1 : 0

  name = var.sns_topic_name
  tags = merge(var.tags, local.default_sns_tags)
}
