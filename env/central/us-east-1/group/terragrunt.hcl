include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../_modules/iam/group"
}

dependencies {
  paths = [
    "${get_parent_terragrunt_dir()}/dev/us-east-1/iam/assume_role/developer", 
    "${get_parent_terragrunt_dir()}/dev/us-east-1/iam/assume_role/devops",
    "${get_parent_terragrunt_dir()}/dev/us-east-1/iam/assume_role/qa",
    "${get_parent_terragrunt_dir()}/uat/us-east-1/iam/assume_role/developer", 
    "${get_parent_terragrunt_dir()}/uat/us-east-1/iam/assume_role/devops",
    "${get_parent_terragrunt_dir()}/uat/us-east-1/iam/assume_role/qa",
    "${get_parent_terragrunt_dir()}/prod/us-east-1/iam/assume_role/developer", 
    "${get_parent_terragrunt_dir()}/prod/us-east-1/iam/assume_role/devops",
    "${get_parent_terragrunt_dir()}/prod/us-east-1/iam/assume_role/qa"
    ]
}

locals {
  global_environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  regional_vars           = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  accounts_prod       = read_terragrunt_config("${get_parent_terragrunt_dir()}/prod/account.hcl")
  accounts_dev        = read_terragrunt_config("${get_parent_terragrunt_dir()}/dev/account.hcl")
  accounts_uat        = read_terragrunt_config("${get_parent_terragrunt_dir()}/uat/account.hcl")
  accounts_data       = read_terragrunt_config("${get_parent_terragrunt_dir()}/data/account.hcl")
  accounts_dataprod       = read_terragrunt_config("${get_parent_terragrunt_dir()}/dataprod/account.hcl")
}

inputs = {
    iam_groups = ["developers","qa","devops","dataengineer"]
    aws_accounts = concat([local.accounts_dev.locals.aws_account_id], [local.accounts_prod.locals.aws_account_id], [local.accounts_uat.locals.aws_account_id], [local.accounts_data.locals.aws_account_id], [local.accounts_dataprod.locals.aws_account_id])
}
