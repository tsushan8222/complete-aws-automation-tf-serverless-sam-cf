variable "env" {
  type        = string
  description = "ENV to run"
  default     = "dev"
}
variable "bucket_name" {
  type        = string
  description = "S3 Bucket name"
}

variable "tags" {
  type        = map(string)
  description = "S3 Tags"
  default     = {}
}
