# Deploys DataDog Macro to an AWS Region

Creates a CloudFormation Macro that can be used to inject datadog extension to SAM or CloudFormation Template.
https://docs.datadoghq.com/serverless/libraries_integrations/macro/

Usage are mentioned in the above docs.

Macro `DatadogServerless` will be available for transformation.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.35 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.35 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudformation_stack.macro](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | The env tag to apply to all data sent to datadog | `string` | n/a | yes |
| <a name="input_macro_stack_name"></a> [macro\_stack\_name](#input\_macro\_stack\_name) | DataDog Macro Stack name | `string` | n/a | yes |
| <a name="input_macro_version"></a> [macro\_version](#input\_macro\_version) | Macro version to be deployed | `string` | `"0.2.4"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace for grouping resources | `string` | `"monitoring"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional Tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_macro_stack"></a> [macro\_stack](#output\_macro\_stack) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->