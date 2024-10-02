variable "secrets" {
  type = list(object({
    name  = string
    value = map(string)
  }))
  description = "List of maps of secrets with key"
}
variable "env" {
  type        = string
  description = "env to deploy"
  default     = "dev"
}