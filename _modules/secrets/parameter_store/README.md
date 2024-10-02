# Parameter Store

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
| [aws_ssm_parameter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | env to deploy | `string` | `"dev"` | no |
| <a name="input_parameters"></a> [parameters](#input\_parameters) | List of parameters name,type and value | <pre>list(object({<br>    name  = string<br>    type  = string<br>    value = string<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_parameter_store_names"></a> [parameter\_store\_names](#output\_parameter\_store\_names) | List of all Parameter Store Map(Name and ARN) |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->