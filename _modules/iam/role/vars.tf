
variable "central_acc_role_arn" {
  type        = string
  description = "Central account role arn for assume role"
}

variable "assume_role_name" {
  type        = string
  description = "Name of the assume role which will be created on the child account."
}

variable "managed_policies" {
  type        = list(string)
  description = "List of the IAM managed policies for assume role"
}

variable "inline_policy" {
  type        = string
  description = "Additional inline policy that need to be attached in the role"
}