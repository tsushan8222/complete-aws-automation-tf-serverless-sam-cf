variable "username" {
  type        = string
  description = "IAM user account"
  validation {
    condition     = can(regex("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$", var.username))
    error_message = "Must be a email id."
  }
}

variable "iam_groups" {
  type        = list(string)
  default     = []
  description = "List of IAM Groups name which will be attached to the IAM user"
}

variable "policies" {
  type        = any
  default     = []
  description = "Additional policies statements of structure policies = [{actions = ['kms:*',] resources = ['*'] principals     = [] not_principals = [] condition      = [] }]"
}

variable "managed_policies" {
  type        = list(string)
  default     = []
  description = "List of managed policies that will be added to individual IAM user "
}

variable "region" {
  type        = string
  description = "AWS Region"
}

variable "sender_email" {
  type        = string
  description = "AWS SES verified sender email address "
}

variable "keybase_pgp_key" {
  type        = string
  description = "Pass keybase PGP key for decryption"
}

variable "bcc" {
  type        = string
  description = "BCC email"
  default     = "devops@homeloanexperts.com.au"
}