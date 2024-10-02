variable "docker_image_name" {
  type        = string
  default     = "codebuild-image"
  description = "Docker Image name"
}
variable "env" {
  type        = string
  default     = "dev"
  description = "Environment to which it runs"
}
variable "aws_region" {
  type        = string
  default     = "ap-southeast-2"
  description = "AWS Region"
}
