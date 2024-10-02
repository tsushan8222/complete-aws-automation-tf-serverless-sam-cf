# DataDog Integration

Module creates IAM roles in AWS account and creates integration with DataDog

Principal identifier for DataDog integration `arn:aws:iam::464622532012:root` and the condition is set to be an external id of DataDog integration.

Ref: https://docs.datadoghq.com/integrations/faq/aws-integration-with-terraform/


### Gotchas

If you should encounter `Datadog is not authorized to perform action sts:AssumeRole Accounts affected: 1234567890, 1234567891 Regions affected: every region Errors began reporting 18m ago, last seen 5m ago` Then perhaps the external ID has changed. Execute `./terraform taint module.datadog.datadog_integration_aws.core[0]` in the root module of the account repo to force a refresh.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.35 |
| <a name="requirement_datadog"></a> [datadog](#requirement\_datadog) | >= 2.10, < 3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.35 |
| <a name="provider_datadog"></a> [datadog](#provider\_datadog) | >= 2.10, < 3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.cloudtrail_access_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.datadog_core](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.datadog_integration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.datadog_core_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.datadog_core_attach_cloudtrail_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.datadog_core_attach_extras](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [datadog_integration_aws.core](https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/integration_aws) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.policydoc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_specific_namespace_rules"></a> [account\_specific\_namespace\_rules](#input\_account\_specific\_namespace\_rules) | account\_specific\_namespace\_rules argument for datadog\_integration\_aws resource | `map(any)` | `{}` | no |
| <a name="input_cloudtrail_bucket_name"></a> [cloudtrail\_bucket\_name](#input\_cloudtrail\_bucket\_name) | CloudTrail Bucket name if you want to ingest logs from trail bucket | `string` | `null` | no |
| <a name="input_datadog_api_key"></a> [datadog\_api\_key](#input\_datadog\_api\_key) | DataDog API key | `string` | n/a | yes |
| <a name="input_datadog_app_key"></a> [datadog\_app\_key](#input\_datadog\_app\_key) | DataDog APP key | `string` | n/a | yes |
| <a name="input_enable_datadog_aws_integration"></a> [enable\_datadog\_aws\_integration](#input\_enable\_datadog\_aws\_integration) | Use datadog provider to give datadog aws account access to our resources | `bool` | `true` | no |
| <a name="input_env"></a> [env](#input\_env) | The env tag to apply to all data sent to datadog | `string` | n/a | yes |
| <a name="input_excluded_regions"></a> [excluded\_regions](#input\_excluded\_regions) | An array of AWS regions to exclude from metrics collection | `list(string)` | `[]` | no |
| <a name="input_extra_policy_arns"></a> [extra\_policy\_arns](#input\_extra\_policy\_arns) | Extra policy arns to attach to the datadog-integration-role | `list(string)` | `[]` | no |
| <a name="input_filter_tags"></a> [filter\_tags](#input\_filter\_tags) | Array of EC2 tags (in the form key:value) defines a filter that Datadog use when collecting metrics from EC2. Wildcards, such as ? (for single characters) and * (for multiple characters) can also be used. Only hosts that match one of the defined tags will be imported into Datadog. The rest will be ignored. | `list(string)` | `[]` | no |
| <a name="input_integration_role_name"></a> [integration\_role\_name](#input\_integration\_role\_name) | Role name for connection between DataDog and AWS | `string` | `"datadog-integration-role"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace tag to apply to all data sent to datadog | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_datadog_iam_role_arn"></a> [datadog\_iam\_role\_arn](#output\_datadog\_iam\_role\_arn) | n/a |
| <a name="output_datadog_iam_role_name"></a> [datadog\_iam\_role\_name](#output\_datadog\_iam\_role\_name) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->