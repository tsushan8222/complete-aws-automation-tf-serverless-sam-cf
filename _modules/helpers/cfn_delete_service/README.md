# CloudFormation webook helper for github delete event
Pipeline provisions codebuild environment reuired for serverless pipleine
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_git_hub_webhook_api_gateway"></a> [git\_hub\_webhook\_api\_gateway](#module\_git\_hub\_webhook\_api\_gateway) | terraform-aws-modules/apigateway-v2/aws |  |
| <a name="module_lambda_git_webhook_action"></a> [lambda\_git\_webhook\_action](#module\_lambda\_git\_webhook\_action) | terraform-aws-modules/lambda/aws | ~> 1.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | Environment to which it runs | `string` | `"dev"` | no |
| <a name="input_github_shared_secret"></a> [github\_shared\_secret](#input\_github\_shared\_secret) | Github Shared secret for webhook | `string` | n/a | yes |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | Service Name | `string` | `"cfn-web-hook-delete-service"` | no |
| <a name="input_sns_arn"></a> [sns\_arn](#input\_sns\_arn) | ARN for SNS to which it sends Build Notifications | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_webhook_url"></a> [webhook\_url](#output\_webhook\_url) | Execution endpoint of APIGW |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->