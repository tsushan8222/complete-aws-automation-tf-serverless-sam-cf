output "parameter_store_names" {
  value = {
    for name, arn in zipmap(
      aws_ssm_parameter.this.*.name,
      aws_ssm_parameter.this.*.arn
    ) :
    name => arn
  }
  description = "List of all Parameter Store Map(Name and ARN)"
}