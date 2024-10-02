# Deploys DataDog Forwarder to an AWS Region

Creates subscription filter and Lambda function with lambda layer to push logs to DataDog.
Datadog Forwarder to ship logs from S3 and CloudWatch, as well as observability data from Lambda functions to Datadog.
https://github.com/DataDog/datadog-serverless-functions/tree/master/aws/logs_monitoring

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
| [aws_cloudformation_stack.datadog_forwarder](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_target_lambda_arns"></a> [additional\_target\_lambda\_arns](#input\_additional\_target\_lambda\_arns) | Comma separated list of Lambda ARNs that will get called asynchronously with the same event the Datadog Forwarder receives. | `string` | `""` | no |
| <a name="input_dd_api_secret_manager_arn"></a> [dd\_api\_secret\_manager\_arn](#input\_dd\_api\_secret\_manager\_arn) | Secret manager ARN that has DataDog API key | `string` | n/a | yes |
| <a name="input_dd_compression_level"></a> [dd\_compression\_level](#input\_dd\_compression\_level) | Set the compression level from 0 (no compression) to 9 (best compression). The default compression level is 6. You may see some benefit with regard to decreased outbound network traffic if you increase the compression level, at the expense of increased Forwarder execution duration. | `number` | `6` | no |
| <a name="input_dd_fetch_lambda_tags"></a> [dd\_fetch\_lambda\_tags](#input\_dd\_fetch\_lambda\_tags) | Let the Forwarder fetch Lambda tags using GetResources API calls and apply them to logs, metrics and traces. If set to true, permission tag:GetResources will be automatically added to the Lambda execution IAM role. | `string` | `"true"` | no |
| <a name="input_dd_forward_log"></a> [dd\_forward\_log](#input\_dd\_forward\_log) | Set to false to disable log forwarding, while continuing to forward other observability data, such as metrics and traces from Lambda functions. | `string` | `"true"` | no |
| <a name="input_dd_forwarder_lambda_function_name"></a> [dd\_forwarder\_lambda\_function\_name](#input\_dd\_forwarder\_lambda\_function\_name) | Lambda function name for forwarder | `string` | `"datadog-forwarder"` | no |
| <a name="input_dd_forwarder_stack_name"></a> [dd\_forwarder\_stack\_name](#input\_dd\_forwarder\_stack\_name) | DataDog forwarder Stack name | `string` | n/a | yes |
| <a name="input_dd_forwarder_template_version"></a> [dd\_forwarder\_template\_version](#input\_dd\_forwarder\_template\_version) | datadog cloudformation template version | `string` | `"3.40.0"` | no |
| <a name="input_dd_http_proxy_url"></a> [dd\_http\_proxy\_url](#input\_dd\_http\_proxy\_url) | Sets the standard web proxy environment variables HTTP\_PROXY and HTTPS\_PROXY. These are the url endpoints your proxy server exposes. Don't use this in combination with AWS Private Link. Make sure to also set DdSkipSslValidation to true. | `string` | `""` | no |
| <a name="input_dd_multiline_log_regex_pattern"></a> [dd\_multiline\_log\_regex\_pattern](#input\_dd\_multiline\_log\_regex\_pattern) | Use the supplied regular expression to detect for a new log line for multiline logs from S3, e.g., use expression '\d{2}\/\d{2}\/\d{4}' for multiline logs beginning with pattern '11/10/2014' | `string` | `""` | no |
| <a name="input_dd_no_proxy"></a> [dd\_no\_proxy](#input\_dd\_no\_proxy) | Sets the standard web proxy environment variable NO\_PROXY. It is a comma-separated list of domain names that should be excluded from the web proxy. | `string` | `""` | no |
| <a name="input_dd_no_ssl"></a> [dd\_no\_ssl](#input\_dd\_no\_ssl) | Disable SSL when forwarding logs, set to true when forwarding logs through a proxy | `string` | `"false"` | no |
| <a name="input_dd_port"></a> [dd\_port](#input\_dd\_port) | The endpoint port to forward the logs to, useful for forwarding logs through a proxy. | `string` | `""` | no |
| <a name="input_dd_scrubbing_rule"></a> [dd\_scrubbing\_rule](#input\_dd\_scrubbing\_rule) | Replace text matching the supplied regular expression with xxxxx (default) or DdScrubbingRuleReplacement (if supplied). Log scrubbing rule is applied to the full JSON-formatted log, including any metadata that is automatically added by the Lambda function. Each instance of a pattern match is replaced until no more matches are found in each log. Note, using inefficient regular expression, such as .*, may slow down the Lambda function. | `string` | `""` | no |
| <a name="input_dd_scrubbing_rule_replacement"></a> [dd\_scrubbing\_rule\_replacement](#input\_dd\_scrubbing\_rule\_replacement) | Replace text matching DdScrubbingRule with the supplied text. | `string` | `""` | no |
| <a name="input_dd_site"></a> [dd\_site](#input\_dd\_site) | Datadog site that your metrics and logs will be sent to | `string` | `"datadoghq.com"` | no |
| <a name="input_dd_skip_ssl_validation"></a> [dd\_skip\_ssl\_validation](#input\_dd\_skip\_ssl\_validation) | Send logs over HTTPS, while NOT validating the certificate provided by the endpoint. This will still encrypt the traffic between the forwarder and the log intake endpoint, but will not verify if the destination SSL certificate is valid. | `string` | `"false"` | no |
| <a name="input_dd_tags"></a> [dd\_tags](#input\_dd\_tags) | Add custom tags to forwarded logs, comma-delimited string, no trailing comma, e.g., env:prod,stack:classic | `string` | `""` | no |
| <a name="input_dd_url"></a> [dd\_url](#input\_dd\_url) | The endpoint URL to forward the logs to, useful for forwarding logs through a proxy | `string` | `""` | no |
| <a name="input_dd_use_compression"></a> [dd\_use\_compression](#input\_dd\_use\_compression) | Set to false to disable log compression. Only valid when sending logs over HTTP | `string` | `"true"` | no |
| <a name="input_dd_use_private_link"></a> [dd\_use\_private\_link](#input\_dd\_use\_private\_link) | Set to true to enable sending logs and metrics via AWS PrivateLink. See https://dtdg.co/private-link. | `string` | `"false"` | no |
| <a name="input_dd_use_tcp"></a> [dd\_use\_tcp](#input\_dd\_use\_tcp) | By default, the forwarder sends logs using HTTPS through the port 443. To send logs over an SSL encrypted TCP connection, set this parameter to true | `string` | `"false"` | no |
| <a name="input_env"></a> [env](#input\_env) | The env tag to apply to all data sent to datadog | `string` | n/a | yes |
| <a name="input_exclude_at_match"></a> [exclude\_at\_match](#input\_exclude\_at\_match) | DO NOT send logs matching the supplied regular expression. If a log matches both the ExcludeAtMatch and IncludeAtMatch, it is excluded. | `string` | `""` | no |
| <a name="input_include_at_match"></a> [include\_at\_match](#input\_include\_at\_match) | ONLY send logs matching the supplied regular expression, and not excluded by ExcludeAtMatch.<br> Filtering rules are applied to the full JSON-formatted log, including any metadata that is automatically added by the Forwarder. However, transformations applied by log pipelines, which occur after logs are sent to Datadog, cannot be used to filter logs in the Forwarder. Using an inefficient regular expression, such as .*, may slow down the Forwarder. | `string` | `""` | no |
| <a name="input_install_as_layer"></a> [install\_as\_layer](#input\_install\_as\_layer) | Whether to use the layer-based installation flow. Set to false to use our legacy installation flow, which installs a second function that copies the forwarder code from GitHub to an S3 bucket. Defaults to true. | `string` | `"true"` | no |
| <a name="input_layer_arn"></a> [layer\_arn](#input\_layer\_arn) | ARN for the layer containing the forwarder code. If empty, the script will use the version of the layer the forwarder was published with. | `string` | `""` | no |
| <a name="input_log_retention_in_days"></a> [log\_retention\_in\_days](#input\_log\_retention\_in\_days) | Log retention in days for the Datadog Forwarder Lambda | `number` | `90` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Memory size for the Datadog Forwarder Lambda function | `number` | `1024` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace for grouping resources | `string` | `"monitoring"` | no |
| <a name="input_permission_boundary_arn"></a> [permission\_boundary\_arn](#input\_permission\_boundary\_arn) | DO NOT CHANGE unless you know what you are doing | `string` | `""` | no |
| <a name="input_redact_email"></a> [redact\_email](#input\_redact\_email) | Replace text matching [a-zA-Z0-9\_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+ with xxxxx@xxxxx.com | `string` | `"false"` | no |
| <a name="input_redact_ip"></a> [redact\_ip](#input\_redact\_ip) | Replace text matching \d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3} with xxx.xxx.xxx.xxx | `string` | `"false"` | no |
| <a name="input_reserved_concurrency"></a> [reserved\_concurrency](#input\_reserved\_concurrency) | Reserved concurrency for the Datadog Forwarder Lambda function. | `number` | `100` | no |
| <a name="input_source_zip_url"></a> [source\_zip\_url](#input\_source\_zip\_url) | DO NOT CHANGE unless you know what you are doing. Override the default location of the function source code. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional Tags | `map(string)` | `{}` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Timeout for the Datadog Forwarder Lambda function | `number` | `120` | no |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | Comma separated list string of VPC Security Group Ids. Used when AWS PrivateLink is enabled. | `string` | `""` | no |
| <a name="input_vpc_subnet_ids"></a> [vpc\_subnet\_ids](#input\_vpc\_subnet\_ids) | Comma separated list of VPC Subnet Ids. Used when AWS PrivateLink is enabled. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_forwarder_stack"></a> [forwarder\_stack](#output\_forwarder\_stack) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->