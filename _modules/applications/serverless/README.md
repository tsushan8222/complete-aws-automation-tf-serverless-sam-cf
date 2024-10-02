# Serverless Application
Base Layer for serverless application to extend
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.this](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_after_deploy_sh_location"></a> [after\_deploy\_sh\_location](#input\_after\_deploy\_sh\_location) | After Deploy Script File location with executable permission | `string` | `null` | no |
| <a name="input_before_deploy_sh_location"></a> [before\_deploy\_sh\_location](#input\_before\_deploy\_sh\_location) | Before Deploy Script File location with executable permission | `string` | `null` | no |
| <a name="input_env_output_file_location"></a> [env\_output\_file\_location](#input\_env\_output\_file\_location) | Output for .env file location | `string` | n/a | yes |
| <a name="input_env_variables"></a> [env\_variables](#input\_env\_variables) | List of environment variables that has to be outputed to env\_file\_location | `list(string)` | n/a | yes |
| <a name="input_serveless_yaml_dir"></a> [serveless\_yaml\_dir](#input\_serveless\_yaml\_dir) | serverless yaml dir location | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->