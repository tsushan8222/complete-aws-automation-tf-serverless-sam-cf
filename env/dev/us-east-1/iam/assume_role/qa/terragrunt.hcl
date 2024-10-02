include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../_modules/iam/role"
}

locals {
    accounts              = read_terragrunt_config("${get_parent_terragrunt_dir()}/central/account.hcl")
    policies = {
    
    }
}

inputs = {   
    central_acc_role_arn = "arn:aws:iam::${local.accounts.locals.aws_account_id}:root"
    assume_role_name = "qa"
    managed_policies = ["ReadOnlyAccess"]
    inline_policy = local.policies == {} ? "" : jsonencode(local.policies)
}