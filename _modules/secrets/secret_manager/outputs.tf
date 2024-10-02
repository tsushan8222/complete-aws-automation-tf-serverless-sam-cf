output "secret_manager" {
  value = {
    for name, id in zipmap(
      aws_secretsmanager_secret.this.*.name,
      aws_secretsmanager_secret.this.*.id
    ) :
    name => id
  }
  description = "List of all Secret manger Map(Name and ID)"
}
