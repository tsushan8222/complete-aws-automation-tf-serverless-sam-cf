include {
  path = find_in_parent_folders()
}
terraform {
  source = "${get_parent_terragrunt_dir()}/../_modules/data_dog/log_ingestion"
}

dependencies {
  paths = ["${get_parent_terragrunt_dir()}/${local.global_environment_vars.locals.environment}/${local.regional_vars.locals.aws_region}/fabric/components/integrations/datadog/forwarder"]
}
dependency "forwarder_stack_output" {
  config_path = "${get_parent_terragrunt_dir()}/${local.global_environment_vars.locals.environment}/${local.regional_vars.locals.aws_region}/fabric/components/integrations/datadog/forwarder"
}

locals {
  global_environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  regional_vars           = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  global_secret_vars      = yamldecode(sops_decrypt_file(find_in_parent_folders("global_secret.${local.global_environment_vars.locals.environment}.yaml")))
}

inputs = {
  datadog_app_key      = local.global_secret_vars.DATADOG_PROVIDER_KEY
  datadog_api_key      = local.global_secret_vars.DATADOG_API_KEY
  lambda_forwarder_arn = dependency.forwarder_stack_output.outputs.forwarder_stack.DatadogForwarderArn
  sevices_to_ingest_logs_from = [
    "lambda",
    "apigw-access-logs",
    "apigw-execution-logs",
    "cloudfront"
  ]
}
