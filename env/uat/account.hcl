# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
locals {
  account_name   = "uat"
  aws_account_id = ""
  aws_profile    = "uat"
}
