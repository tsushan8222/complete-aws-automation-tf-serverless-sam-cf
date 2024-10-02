# SNS Topic Configuration

Configure SNS topic and subscription as

```json
  sns_topic_name                      = sns_topic_name
  aws_sns_topic_subscription_protocal = "email"
  aws_sns_topic_subscription_endpoint = "test@test.com"
```

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
| [aws_lambda_permission.with_sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_sns_topic.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_sns_topic_subscription.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.sns_topic_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_sns_topic_subscription_endpoint"></a> [aws\_sns\_topic\_subscription\_endpoint](#input\_aws\_sns\_topic\_subscription\_endpoint) | Subscription endpoint can be (ARN \| EMAIL \| http \| https) | `string` | n/a | yes |
| <a name="input_aws_sns_topic_subscription_protocal"></a> [aws\_sns\_topic\_subscription\_protocal](#input\_aws\_sns\_topic\_subscription\_protocal) | Protocal Name values can be (application \| lambda \| sms \| sqs \| email \| email-json \| http \| https) | `string` | n/a | yes |
| <a name="input_create_sns_topic"></a> [create\_sns\_topic](#input\_create\_sns\_topic) | Whether to create the SNS topic | `bool` | `true` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment to which it runs | `string` | `"dev"` | no |
| <a name="input_sns_topic_name"></a> [sns\_topic\_name](#input\_sns\_topic\_name) | The name of the SNS topic to create | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | SNS Tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sns_topic_arn"></a> [sns\_topic\_arn](#output\_sns\_topic\_arn) | ARN of SNS topic |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
