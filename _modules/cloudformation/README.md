# Provisions Cloudformation template and it's resources

Provisions the resources passed in template body



<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudformation_stack.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | Environment to which it runs | `string` | `"dev"` | no |
| <a name="input_parameters"></a> [parameters](#input\_parameters) | CloudFormation Parameters Key value | `map(string)` | `{}` | no |
| <a name="input_stack_name"></a> [stack\_name](#input\_stack\_name) | CloudFormation stack name | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional Tags to propagate | `map(string)` | `{}` | no |
| <a name="input_template_body"></a> [template\_body](#input\_template\_body) | JSON/YAML string body | `string` | n/a | yes |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | timeout for stack operation | `string` | `"60m"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cfn_outputs"></a> [cfn\_outputs](#output\_cfn\_outputs) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
