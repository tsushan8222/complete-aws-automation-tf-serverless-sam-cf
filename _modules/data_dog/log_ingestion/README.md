# DataDog Configuration of log ingestion from services

Module creates integration of account, service and Log Forwarder


Ref: https://docs.datadoghq.com/logs/guide/send-aws-services-logs-with-the-datadog-lambda-function/?tab=terraform#manually-set-up-triggers


### Gotchas
Update operations are currently not supported with datadog API so any change forces a new resource.


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
| [datadog_integration_aws_lambda_arn.main_collector](https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/integration_aws_lambda_arn) | resource |
| [datadog_integration_aws_log_collection.main](https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/integration_aws_log_collection) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_datadog_api_key"></a> [datadog\_api\_key](#input\_datadog\_api\_key) | DataDog API key | `string` | n/a | yes |
| <a name="input_datadog_app_key"></a> [datadog\_app\_key](#input\_datadog\_app\_key) | DataDog APP key | `string` | n/a | yes |
| <a name="input_lambda_forwarder_arn"></a> [lambda\_forwarder\_arn](#input\_lambda\_forwarder\_arn) | forwarder ARN for log configuration integration | `string` | n/a | yes |
| <a name="input_sevices_to_ingest_logs_from"></a> [sevices\_to\_ingest\_logs\_from](#input\_sevices\_to\_ingest\_logs\_from) | List of services to collect logs from with forwarder | `list(string)` | <pre>[<br>  "lambda"<br>]</pre> | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->