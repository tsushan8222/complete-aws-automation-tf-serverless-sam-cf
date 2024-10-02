variable "artifact_bucket_name" {
  type        = string
  description = "Artifact Bucket name "
}
variable "logging_bucket_name" {
  type        = string
  description = "Logging Bucket name "
}
variable "tf_state_bucket_name" {
  type        = string
  description = "Logging Bucket name "
}
variable "policies" {
  type        = any
  default     = []
  description = "Additional policies statements of structure policies = [{actions = ['kms:*',] resources = ['*'] principals     = [] not_principals = [] condition      = [] }]"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional Tags to propagate"
}
variable "iam_tags" {
  type        = map(string)
  default     = { "role" = "codebuild" }
  description = "Default IAM tags"
}

variable "github_pat" {
  type        = string
  description = "Github Personal Access Token"
}
variable "github_shared_secret" {
  type        = string
  description = "Github Shared secret for webhook"
}

variable "application_name" {
  type        = string
  description = "Application Name"
}

variable "application_role" {
  type        = string
  description = "Application role for tf state file"
}
variable "project_path" {
  type        = string
  description = "Project path relative to project root"
  default     = "./"
}
variable "node_version" {
  type        = string
  description = "Node Version"
  default     = "12"
}
variable "env" {
  type        = string
  default     = "dev"
  description = "Environment to which it runs"
}
variable "build_timeout" {
  type        = number
  default     = 60
  description = "Build Timeout in minutes"
}

variable "build_image" {
  type        = string
  default     = "aws/codebuild/standard:5.0"
  description = "Build environment image"
}
variable "build_compute_size" {
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
  description = "Compute size for build environment"
}
variable "git_repo_url" {
  type        = string
  description = "Git repo url in https format"
}

variable "git_branch" {
  type        = string
  default     = "develop"
  description = "Git branch on which trigger occurs"
}
variable "git_hub_organization" {
  type        = string
  default     = "hlexperts"
  description = "Github Organization Name"
}
variable "env_variables" {
  type = list(map(string))
  default = [{
    name  = "role"
    value = "codebuild"
    type  = "PLAINTEXT"
  }]
  description = "List of pipeline environment variables in format [{ name  = 'role' value = 'codebuild'type  = 'PLAINTEXT' }]"
}

variable "sns_arn" {
  type        = string
  description = "ARN for SNS to which it sends Build Notifications"
}

variable "multi_branch" {
  type        = bool
  description = "Supports Multi branch deployment or not"
  default     = false
}

variable "github_package_org" {
  type        = string
  description = "Github Package Org"
  default     = "hlexperts"
}

variable "enable_report" {
  type        = bool
  description = "Report Group Enable"
  default     = false
}
