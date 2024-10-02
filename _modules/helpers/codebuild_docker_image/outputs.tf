output "docker_repository_url" {
  value       = aws_ecr_repository.this.repository_url
  description = "AWS CodeBuild Docker Repository URL"
}
output "docker_repository_id" {
  value       = aws_ecr_repository.this.registry_id
  description = "AWS CodeBuild Docker Repository ID"
}
output "docker_repository_arn" {
  value       = aws_ecr_repository.this.arn
  description = "AWS CodeBuild Docker Repository ARN"
}
