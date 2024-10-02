resource "aws_secretsmanager_secret" "dd_api_key" {
  name        = var.dd_api_key_name
  description = "Encrypted Datadog API Key"

  tags = merge(var.tags, local.default_tags)
}

resource "aws_secretsmanager_secret_version" "dd_api_key" {
  secret_id     = aws_secretsmanager_secret.dd_api_key.id
  secret_string = var.dd_api_key
}
