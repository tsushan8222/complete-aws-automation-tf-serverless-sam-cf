include {
  path = find_in_parent_folders()
}
terraform {
  source = "${get_parent_terragrunt_dir()}/../_modules/helpers/codebuild_docker_image"
}

locals {
  global_environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  regional_vars           = read_terragrunt_config(find_in_parent_folders("region.hcl"))
}
inputs = {
  env               = local.global_environment_vars.locals.environment
  aws_region        = local.regional_vars.locals.aws_region
  docker_image_name = "codebuild-image"

}
