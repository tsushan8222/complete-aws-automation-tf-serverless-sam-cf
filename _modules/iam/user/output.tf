output "user_arn" {
  value       = aws_iam_user.user.arn
  description = "Output of created AWS user account arn "
}

output "password" {
  value       = aws_iam_user_login_profile.this.encrypted_password
  sensitive   = true
  description = "Password of the created AWS user account"
}