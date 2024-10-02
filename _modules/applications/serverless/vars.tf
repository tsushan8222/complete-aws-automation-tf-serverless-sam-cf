variable "serveless_yaml_dir" {
  type        = string
  description = "serverless yaml dir location"
}
variable "env_output_file_location" {
  type        = string
  description = "Output for .env file location"
}
variable "env_variables" {
  type        = list(string)
  description = "List of environment variables that has to be outputed to env_file_location"
}
variable "before_deploy_sh_location" {
  type        = string
  default     = null
  description = "Before Deploy Script File location with executable permission"
}
variable "after_deploy_sh_location" {
  type        = string
  default     = null
  description = "After Deploy Script File location with executable permission"
}
