# Secret Manager

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
| [aws_secretsmanager_secret.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | env to deploy | `string` | `"dev"` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | List of maps of secrets with key | <pre>list(object({<br>    name  = string<br>    value = map(string)<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_secret_manager"></a> [secret\_manager](#output\_secret\_manager) | List of all Secret manger Map(Name and ID) |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->