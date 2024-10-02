resource "aws_secretsmanager_secret" "this" {
  count = length(var.secrets)
  name  = var.secrets[count.index].name
  tags = {
    name = var.secrets[count.index].name
    env  = var.env
  }
}

resource "aws_secretsmanager_secret_version" "this" {
  count         = length(var.secrets)
  secret_id     = aws_secretsmanager_secret.this[count.index].id
  secret_string = jsonencode(var.secrets[count.index].value)
}
