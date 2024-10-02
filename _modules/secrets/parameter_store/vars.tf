variable "parameters" {
  type = list(object({
    name  = string
    type  = string
    value = string
  }))
  description = "List of parameters name,type and value"
}
variable "env" {
  type        = string
  description = "env to deploy"
  default     = "dev"
}
