# DataDog API Key encryption using secrets manager

Stores DataDog API key in AWS secret manager and outputs the ARN for reference.

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
| [aws_secretsmanager_secret.dd_api_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.dd_api_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dd_api_key"></a> [dd\_api\_key](#input\_dd\_api\_key) | Datadog API key | `string` | n/a | yes |
| <a name="input_dd_api_key_name"></a> [dd\_api\_key\_name](#input\_dd\_api\_key\_name) | Datadog API key name | `string` | `"datadog_api_key"` | no |
| <a name="input_env"></a> [env](#input\_env) | The env tag to apply to all data sent to datadog | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace for grouping resources | `string` | `"monitoring"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional Tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dd_api_key"></a> [dd\_api\_key](#output\_dd\_api\_key) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->