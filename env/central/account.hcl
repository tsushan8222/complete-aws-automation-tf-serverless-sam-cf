# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
locals {
  account_name   = "central"
  aws_account_id = ""
  aws_profile    = "central"
}
