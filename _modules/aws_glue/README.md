# Provisions AWS Glue and Other dependency
Derived from https://github.com/SebastianUA/terraform-aws-glue

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.17.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.17.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_glue_catalog_database.glue_catalog_database](https://registry.terraform.io/providers/hashicorp/aws/4.17.1/docs/resources/glue_catalog_database) | resource |
| [aws_glue_catalog_table.glue_catalog_table](https://registry.terraform.io/providers/hashicorp/aws/4.17.1/docs/resources/glue_catalog_table) | resource |
| [aws_glue_classifier.glue_classifier](https://registry.terraform.io/providers/hashicorp/aws/4.17.1/docs/resources/glue_classifier) | resource |
| [aws_glue_connection.glue_connection](https://registry.terraform.io/providers/hashicorp/aws/4.17.1/docs/resources/glue_connection) | resource |
| [aws_glue_crawler.glue_crawler](https://registry.terraform.io/providers/hashicorp/aws/4.17.1/docs/resources/glue_crawler) | resource |
| [aws_glue_data_catalog_encryption_settings.glue_data_catalog_encryption_settings](https://registry.terraform.io/providers/hashicorp/aws/4.17.1/docs/resources/glue_data_catalog_encryption_settings) | resource |
| [aws_glue_dev_endpoint.glue_dev_endpoint](https://registry.terraform.io/providers/hashicorp/aws/4.17.1/docs/resources/glue_dev_endpoint) | resource |
| [aws_glue_job.glue_job](https://registry.terraform.io/providers/hashicorp/aws/4.17.1/docs/resources/glue_job) | resource |
| [aws_glue_ml_transform.glue_ml_transform](https://registry.terraform.io/providers/hashicorp/aws/4.17.1/docs/resources/glue_ml_transform) | resource |
| [aws_glue_partition.glue_partition](https://registry.terraform.io/providers/hashicorp/aws/4.17.1/docs/resources/glue_partition) | resource |
| [aws_glue_registry.glue_registry](https://registry.terraform.io/providers/hashicorp/aws/4.17.1/docs/resources/glue_registry) | resource |
| [aws_glue_resource_policy.glue_resource_policy](https://registry.terraform.io/providers/hashicorp/aws/4.17.1/docs/resources/glue_resource_policy) | resource |
| [aws_glue_schema.glue_schema](https://registry.terraform.io/providers/hashicorp/aws/4.17.1/docs/resources/glue_schema) | resource |
| [aws_glue_security_configuration.glue_security_configuration](https://registry.terraform.io/providers/hashicorp/aws/4.17.1/docs/resources/glue_security_configuration) | resource |
| [aws_glue_trigger.glue_trigger](https://registry.terraform.io/providers/hashicorp/aws/4.17.1/docs/resources/glue_trigger) | resource |
| [aws_glue_user_defined_function.glue_user_defined_function](https://registry.terraform.io/providers/hashicorp/aws/4.17.1/docs/resources/glue_user_defined_function) | resource |
| [aws_glue_workflow.glue_workflow](https://registry.terraform.io/providers/hashicorp/aws/4.17.1/docs/resources/glue_workflow) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_glue_connections"></a> [aws\_glue\_connections](#input\_aws\_glue\_connections) | (Optional) List of AWS Glue Connection configurations | `list(any)` | `[]` | no |
| <a name="input_enable_glue_catalog_database"></a> [enable\_glue\_catalog\_database](#input\_enable\_glue\_catalog\_database) | Enable glue catalog database usage | `bool` | `false` | no |
| <a name="input_enable_glue_catalog_table"></a> [enable\_glue\_catalog\_table](#input\_enable\_glue\_catalog\_table) | Enable glue catalog table usage | `bool` | `false` | no |
| <a name="input_enable_glue_classifier"></a> [enable\_glue\_classifier](#input\_enable\_glue\_classifier) | Enable glue classifier usage | `bool` | `false` | no |
| <a name="input_enable_glue_crawler"></a> [enable\_glue\_crawler](#input\_enable\_glue\_crawler) | Enable glue crawler usage | `bool` | `false` | no |
| <a name="input_enable_glue_data_catalog_encryption_settings"></a> [enable\_glue\_data\_catalog\_encryption\_settings](#input\_enable\_glue\_data\_catalog\_encryption\_settings) | Enable glue data catalog encryption settings usage | `bool` | `false` | no |
| <a name="input_enable_glue_dev_endpoint"></a> [enable\_glue\_dev\_endpoint](#input\_enable\_glue\_dev\_endpoint) | Enable glue dev endpoint usage | `bool` | `false` | no |
| <a name="input_enable_glue_job"></a> [enable\_glue\_job](#input\_enable\_glue\_job) | Enable glue job usage | `bool` | `false` | no |
| <a name="input_enable_glue_ml_transform"></a> [enable\_glue\_ml\_transform](#input\_enable\_glue\_ml\_transform) | Enable glue ml transform usage | `bool` | `false` | no |
| <a name="input_enable_glue_partition"></a> [enable\_glue\_partition](#input\_enable\_glue\_partition) | Enable glue partition usage | `bool` | `false` | no |
| <a name="input_enable_glue_registry"></a> [enable\_glue\_registry](#input\_enable\_glue\_registry) | Enable glue registry usage | `bool` | `false` | no |
| <a name="input_enable_glue_resource_policy"></a> [enable\_glue\_resource\_policy](#input\_enable\_glue\_resource\_policy) | Enable glue resource policy usage | `bool` | `false` | no |
| <a name="input_enable_glue_schema"></a> [enable\_glue\_schema](#input\_enable\_glue\_schema) | Enable glue schema usage | `bool` | `false` | no |
| <a name="input_enable_glue_security_configuration"></a> [enable\_glue\_security\_configuration](#input\_enable\_glue\_security\_configuration) | Enable glue security configuration usage | `bool` | `false` | no |
| <a name="input_enable_glue_trigger"></a> [enable\_glue\_trigger](#input\_enable\_glue\_trigger) | Enable glue trigger usage | `bool` | `false` | no |
| <a name="input_enable_glue_user_defined_function"></a> [enable\_glue\_user\_defined\_function](#input\_enable\_glue\_user\_defined\_function) | Enable glue user defined function usage | `bool` | `false` | no |
| <a name="input_enable_glue_workflow"></a> [enable\_glue\_workflow](#input\_enable\_glue\_workflow) | Enable glue workflow usage | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment to apply resources on | `string` | `"dev"` | no |
| <a name="input_glue_catalog_database_catalog_id"></a> [glue\_catalog\_database\_catalog\_id](#input\_glue\_catalog\_database\_catalog\_id) | (Optional) ID of the Glue Catalog to create the database in. If omitted, this defaults to the AWS Account ID. | `string` | `null` | no |
| <a name="input_glue_catalog_database_description"></a> [glue\_catalog\_database\_description](#input\_glue\_catalog\_database\_description) | (Optional) Description of the database. | `string` | `null` | no |
| <a name="input_glue_catalog_database_location_uri"></a> [glue\_catalog\_database\_location\_uri](#input\_glue\_catalog\_database\_location\_uri) | (Optional) The location of the database (for example, an HDFS path). | `string` | `null` | no |
| <a name="input_glue_catalog_database_name"></a> [glue\_catalog\_database\_name](#input\_glue\_catalog\_database\_name) | The name of the database. | `string` | `""` | no |
| <a name="input_glue_catalog_database_parameters"></a> [glue\_catalog\_database\_parameters](#input\_glue\_catalog\_database\_parameters) | (Optional) A list of key-value pairs that define parameters and properties of the database. | `map(any)` | `null` | no |
| <a name="input_glue_catalog_databases_config"></a> [glue\_catalog\_databases\_config](#input\_glue\_catalog\_databases\_config) | list of Glue Catalog Configurations | `list(any)` | `[]` | no |
| <a name="input_glue_classifier_csv_classifier"></a> [glue\_classifier\_csv\_classifier](#input\_glue\_classifier\_csv\_classifier) | (Optional) A classifier for Csv content. | `list(any)` | `[]` | no |
| <a name="input_glue_classifier_grok_classifier"></a> [glue\_classifier\_grok\_classifier](#input\_glue\_classifier\_grok\_classifier) | (Optional) A classifier for grok content. | `list(any)` | `[]` | no |
| <a name="input_glue_classifier_json_classifier"></a> [glue\_classifier\_json\_classifier](#input\_glue\_classifier\_json\_classifier) | (Optional) A classifier for json content. | `list(any)` | `[]` | no |
| <a name="input_glue_classifier_name"></a> [glue\_classifier\_name](#input\_glue\_classifier\_name) | The name of the classifier. | `string` | `""` | no |
| <a name="input_glue_classifier_xml_classifier"></a> [glue\_classifier\_xml\_classifier](#input\_glue\_classifier\_xml\_classifier) | (Optional) A classifier for xml content. | `list(any)` | `[]` | no |
| <a name="input_glue_crawlers"></a> [glue\_crawlers](#input\_glue\_crawlers) | List Of Glue Crawlers Configurations | `list(any)` | `[]` | no |
| <a name="input_glue_data_catalog_encryption_settings_catalog_id"></a> [glue\_data\_catalog\_encryption\_settings\_catalog\_id](#input\_glue\_data\_catalog\_encryption\_settings\_catalog\_id) | (Optional) The ID of the Data Catalog to set the security configuration for. If none is provided, the AWS account ID is used by default. | `string` | `null` | no |
| <a name="input_glue_data_catalog_encryption_settings_data_catalog_encryption_settings"></a> [glue\_data\_catalog\_encryption\_settings\_data\_catalog\_encryption\_settings](#input\_glue\_data\_catalog\_encryption\_settings\_data\_catalog\_encryption\_settings) | Set data\_catalog\_encryption\_settings block for Glue data catalog encryption | `map(any)` | `{}` | no |
| <a name="input_glue_dev_endpoint_arguments"></a> [glue\_dev\_endpoint\_arguments](#input\_glue\_dev\_endpoint\_arguments) | (Optional) A map of arguments used to configure the endpoint. | `map(any)` | `null` | no |
| <a name="input_glue_dev_endpoint_extra_jars_s3_path"></a> [glue\_dev\_endpoint\_extra\_jars\_s3\_path](#input\_glue\_dev\_endpoint\_extra\_jars\_s3\_path) | (Optional) Path to one or more Java Jars in an S3 bucket that should be loaded in this endpoint. | `any` | `null` | no |
| <a name="input_glue_dev_endpoint_extra_python_libs_s3_path"></a> [glue\_dev\_endpoint\_extra\_python\_libs\_s3\_path](#input\_glue\_dev\_endpoint\_extra\_python\_libs\_s3\_path) | (Optional) Path(s) to one or more Python libraries in an S3 bucket that should be loaded in this endpoint. Multiple values must be complete paths separated by a comma. | `any` | `null` | no |
| <a name="input_glue_dev_endpoint_glue_version"></a> [glue\_dev\_endpoint\_glue\_version](#input\_glue\_dev\_endpoint\_glue\_version) | (Optional) - Specifies the versions of Python and Apache Spark to use. Defaults to AWS Glue version 0.9. | `any` | `null` | no |
| <a name="input_glue_dev_endpoint_name"></a> [glue\_dev\_endpoint\_name](#input\_glue\_dev\_endpoint\_name) | The name of this endpoint. It must be unique in your account. | `string` | `""` | no |
| <a name="input_glue_dev_endpoint_number_of_nodes"></a> [glue\_dev\_endpoint\_number\_of\_nodes](#input\_glue\_dev\_endpoint\_number\_of\_nodes) | (Optional) The number of AWS Glue Data Processing Units (DPUs) to allocate to this endpoint. Conflicts with worker\_type | `any` | `null` | no |
| <a name="input_glue_dev_endpoint_number_of_workers"></a> [glue\_dev\_endpoint\_number\_of\_workers](#input\_glue\_dev\_endpoint\_number\_of\_workers) | (Optional) The number of workers of a defined worker type that are allocated to this endpoint. This field is available only when you choose worker type G.1X or G.2X. | `any` | `null` | no |
| <a name="input_glue_dev_endpoint_public_key"></a> [glue\_dev\_endpoint\_public\_key](#input\_glue\_dev\_endpoint\_public\_key) | (Optional) The public key to be used by this endpoint for authentication. | `any` | `null` | no |
| <a name="input_glue_dev_endpoint_public_keys"></a> [glue\_dev\_endpoint\_public\_keys](#input\_glue\_dev\_endpoint\_public\_keys) | (Optional) A list of public keys to be used by this endpoint for authentication. | `any` | `null` | no |
| <a name="input_glue_dev_endpoint_role_arn"></a> [glue\_dev\_endpoint\_role\_arn](#input\_glue\_dev\_endpoint\_role\_arn) | (Required) The IAM role for this endpoint. | `string` | `null` | no |
| <a name="input_glue_dev_endpoint_security_configuration"></a> [glue\_dev\_endpoint\_security\_configuration](#input\_glue\_dev\_endpoint\_security\_configuration) | (Optional) The name of the Security Configuration structure to be used with this endpoint. | `any` | `null` | no |
| <a name="input_glue_dev_endpoint_security_group_ids"></a> [glue\_dev\_endpoint\_security\_group\_ids](#input\_glue\_dev\_endpoint\_security\_group\_ids) | (Optional) Security group IDs for the security groups to be used by this endpoint. | `any` | `null` | no |
| <a name="input_glue_dev_endpoint_subnet_id"></a> [glue\_dev\_endpoint\_subnet\_id](#input\_glue\_dev\_endpoint\_subnet\_id) | (Optional) The subnet ID for the new endpoint to use. | `any` | `null` | no |
| <a name="input_glue_dev_endpoint_worker_type"></a> [glue\_dev\_endpoint\_worker\_type](#input\_glue\_dev\_endpoint\_worker\_type) | (Optional) The type of predefined worker that is allocated to this endpoint. Accepts a value of Standard, G.1X, or G.2X. | `any` | `null` | no |
| <a name="input_glue_job_additional_connections"></a> [glue\_job\_additional\_connections](#input\_glue\_job\_additional\_connections) | (Optional) The list of connections used for the job. | `list(any)` | `[]` | no |
| <a name="input_glue_job_command"></a> [glue\_job\_command](#input\_glue\_job\_command) | (Required) The command of the job. | `list(any)` | `[]` | no |
| <a name="input_glue_job_connections"></a> [glue\_job\_connections](#input\_glue\_job\_connections) | (Optional) The list of connections used for this job. | `list(any)` | `[]` | no |
| <a name="input_glue_job_default_arguments"></a> [glue\_job\_default\_arguments](#input\_glue\_job\_default\_arguments) | (Optional) The map of default arguments for this job. You can specify arguments here that your own job-execution script consumes, as well as arguments that AWS Glue itself consumes. For information about how to specify and consume your own Job arguments, see the Calling AWS Glue APIs in Python topic in the developer guide. For information about the key-value pairs that AWS Glue consumes to set up your job, see the Special Parameters Used by AWS Glue topic in the developer guide. | `map(any)` | <pre>{<br>  "--job-language": "python"<br>}</pre> | no |
| <a name="input_glue_job_description"></a> [glue\_job\_description](#input\_glue\_job\_description) | (Optional) Description of the job. | `string` | `null` | no |
| <a name="input_glue_job_execution_property"></a> [glue\_job\_execution\_property](#input\_glue\_job\_execution\_property) | (Optional) Execution property of the job. | `list(any)` | `[]` | no |
| <a name="input_glue_job_glue_version"></a> [glue\_job\_glue\_version](#input\_glue\_job\_glue\_version) | (Optional) The version of glue to use, for example '1.0'. For information about available versions, see the AWS Glue Release Notes. | `string` | `null` | no |
| <a name="input_glue_job_max_capacity"></a> [glue\_job\_max\_capacity](#input\_glue\_job\_max\_capacity) | (Optional) The maximum number of AWS Glue data processing units (DPUs) that can be allocated when this job runs. Required when pythonshell is set, accept either 0.0625 or 1.0. | `string` | `null` | no |
| <a name="input_glue_job_max_retries"></a> [glue\_job\_max\_retries](#input\_glue\_job\_max\_retries) | (Optional) The maximum number of times to retry this job if it fails. | `string` | `null` | no |
| <a name="input_glue_job_name"></a> [glue\_job\_name](#input\_glue\_job\_name) | The name you assign to this job. It must be unique in your account. | `string` | `""` | no |
| <a name="input_glue_job_notification_property"></a> [glue\_job\_notification\_property](#input\_glue\_job\_notification\_property) | (Optional) Notification property of the job. | `list(any)` | `[]` | no |
| <a name="input_glue_job_number_of_workers"></a> [glue\_job\_number\_of\_workers](#input\_glue\_job\_number\_of\_workers) | (Optional) The number of workers of a defined workerType that are allocated when a job runs. | `number` | `null` | no |
| <a name="input_glue_job_role_arn"></a> [glue\_job\_role\_arn](#input\_glue\_job\_role\_arn) | The ARN of the IAM role associated with this job. | `string` | `null` | no |
| <a name="input_glue_job_security_configuration"></a> [glue\_job\_security\_configuration](#input\_glue\_job\_security\_configuration) | (Optional) The name of the Security Configuration to be associated with the job. | `string` | `null` | no |
| <a name="input_glue_job_timeout"></a> [glue\_job\_timeout](#input\_glue\_job\_timeout) | (Optional) The job timeout in minutes. The default is 2880 minutes (48 hours). | `number` | `2880` | no |
| <a name="input_glue_job_worker_type"></a> [glue\_job\_worker\_type](#input\_glue\_job\_worker\_type) | (Optional) The type of predefined worker that is allocated when a job runs. Accepts a value of Standard, G.1X, or G.2X. | `string` | `null` | no |
| <a name="input_glue_ml_transform_description"></a> [glue\_ml\_transform\_description](#input\_glue\_ml\_transform\_description) | (Optional) Description of the ML Transform. | `any` | `null` | no |
| <a name="input_glue_ml_transform_glue_version"></a> [glue\_ml\_transform\_glue\_version](#input\_glue\_ml\_transform\_glue\_version) | (Optional) The version of glue to use, for example '1.0'. For information about available versions, see the AWS Glue Release Notes. | `any` | `null` | no |
| <a name="input_glue_ml_transform_input_record_tables"></a> [glue\_ml\_transform\_input\_record\_tables](#input\_glue\_ml\_transform\_input\_record\_tables) | (Required) A list of AWS Glue table definitions used by the transform. see Input Record Tables. | `list` | `[]` | no |
| <a name="input_glue_ml_transform_max_capacity"></a> [glue\_ml\_transform\_max\_capacity](#input\_glue\_ml\_transform\_max\_capacity) | (Optional) The number of AWS Glue data processing units (DPUs) that are allocated to task runs for this transform. You can allocate from 2 to 100 DPUs; the default is 10. max\_capacity is a mutually exclusive option with number\_of\_workers and worker\_type. | `any` | `null` | no |
| <a name="input_glue_ml_transform_max_retries"></a> [glue\_ml\_transform\_max\_retries](#input\_glue\_ml\_transform\_max\_retries) | (Optional) The maximum number of times to retry this ML Transform if it fails. | `any` | `null` | no |
| <a name="input_glue_ml_transform_name"></a> [glue\_ml\_transform\_name](#input\_glue\_ml\_transform\_name) | The name you assign to this ML Transform. It must be unique in your account. | `string` | `""` | no |
| <a name="input_glue_ml_transform_number_of_workers"></a> [glue\_ml\_transform\_number\_of\_workers](#input\_glue\_ml\_transform\_number\_of\_workers) | (Optional) The number of workers of a defined worker\_type that are allocated when an ML Transform runs. Required with worker\_type | `any` | `null` | no |
| <a name="input_glue_ml_transform_parameters"></a> [glue\_ml\_transform\_parameters](#input\_glue\_ml\_transform\_parameters) | (Required) The algorithmic parameters that are specific to the transform type used. Conditionally dependent on the transform type. see Parameters. | `list` | `[]` | no |
| <a name="input_glue_ml_transform_role_arn"></a> [glue\_ml\_transform\_role\_arn](#input\_glue\_ml\_transform\_role\_arn) | (Required) The ARN of the IAM role associated with this ML Transform. | `any` | `null` | no |
| <a name="input_glue_ml_transform_timeout"></a> [glue\_ml\_transform\_timeout](#input\_glue\_ml\_transform\_timeout) | (Optional) The ML Transform timeout in minutes. The default is 2880 minutes (48 hours). | `any` | `null` | no |
| <a name="input_glue_ml_transform_worker_type"></a> [glue\_ml\_transform\_worker\_type](#input\_glue\_ml\_transform\_worker\_type) | (Optional) The type of predefined worker that is allocated when an ML Transform runs. Accepts a value of Standard, G.1X, or G.2X. Required with number\_of\_workers. | `any` | `null` | no |
| <a name="input_glue_partition_catalog_id"></a> [glue\_partition\_catalog\_id](#input\_glue\_partition\_catalog\_id) | (Optional) ID of the Glue Catalog and database to create the table in. If omitted, this defaults to the AWS Account ID plus the database name. | `string` | `null` | no |
| <a name="input_glue_partition_database_name"></a> [glue\_partition\_database\_name](#input\_glue\_partition\_database\_name) | Name of the metadata database where the table metadata resides. For Hive compatibility, this must be all lowercase. | `string` | `""` | no |
| <a name="input_glue_partition_parameters"></a> [glue\_partition\_parameters](#input\_glue\_partition\_parameters) | (Optional) Properties associated with this table, as a list of key-value pairs. | `map(any)` | `null` | no |
| <a name="input_glue_partition_partition_values"></a> [glue\_partition\_partition\_values](#input\_glue\_partition\_partition\_values) | (Required) The values that define the partition. | `list` | `[]` | no |
| <a name="input_glue_partition_storage_descriptor"></a> [glue\_partition\_storage\_descriptor](#input\_glue\_partition\_storage\_descriptor) | (Optional) A storage descriptor object containing information about the physical storage of this table. You can refer to the Glue Developer Guide for a full explanation of this object. | `map(any)` | <pre>{<br>  "bucket_columns": null,<br>  "compressed": null,<br>  "input_format": null,<br>  "location": null,<br>  "number_of_buckets": null,<br>  "output_format": null,<br>  "parameters": null,<br>  "stored_as_sub_directories": null<br>}</pre> | no |
| <a name="input_glue_partition_table_name"></a> [glue\_partition\_table\_name](#input\_glue\_partition\_table\_name) | Table name | `string` | `""` | no |
| <a name="input_glue_registry_description"></a> [glue\_registry\_description](#input\_glue\_registry\_description) | (Optional) A description of the registry. | `any` | `null` | no |
| <a name="input_glue_registry_name"></a> [glue\_registry\_name](#input\_glue\_registry\_name) | The Name of the registry. | `string` | `""` | no |
| <a name="input_glue_resource_policy"></a> [glue\_resource\_policy](#input\_glue\_resource\_policy) | (Required) The policy to be applied to the aws glue data catalog. | `any` | `null` | no |
| <a name="input_glue_schema_compatibility"></a> [glue\_schema\_compatibility](#input\_glue\_schema\_compatibility) | (Required) The compatibility mode of the schema. Values values are: NONE, DISABLED, BACKWARD, BACKWARD\_ALL, FORWARD, FORWARD\_ALL, FULL, and FULL\_ALL. | `any` | `null` | no |
| <a name="input_glue_schema_data_format"></a> [glue\_schema\_data\_format](#input\_glue\_schema\_data\_format) | (Required) The data format of the schema definition. Currently only AVRO is supported. | `any` | `null` | no |
| <a name="input_glue_schema_description"></a> [glue\_schema\_description](#input\_glue\_schema\_description) | (Optional) A description of the schema. | `any` | `null` | no |
| <a name="input_glue_schema_name"></a> [glue\_schema\_name](#input\_glue\_schema\_name) | The Name of the schema. | `string` | `""` | no |
| <a name="input_glue_schema_registry_arn"></a> [glue\_schema\_registry\_arn](#input\_glue\_schema\_registry\_arn) | The ARN of the Glue Registry to create the schema in. | `string` | `""` | no |
| <a name="input_glue_schema_schema_definition"></a> [glue\_schema\_schema\_definition](#input\_glue\_schema\_schema\_definition) | (Required) The schema definition using the data\_format setting for schema\_name. | `any` | `null` | no |
| <a name="input_glue_security_configuration_encryption_configuration"></a> [glue\_security\_configuration\_encryption\_configuration](#input\_glue\_security\_configuration\_encryption\_configuration) | Set encryption configuration for Glue security configuration | `map(any)` | `{}` | no |
| <a name="input_glue_security_configuration_name"></a> [glue\_security\_configuration\_name](#input\_glue\_security\_configuration\_name) | Name of the security configuration. | `string` | `""` | no |
| <a name="input_glue_trigger_actions"></a> [glue\_trigger\_actions](#input\_glue\_trigger\_actions) | (Required) List of actions initiated by this trigger when it fires. | `list(any)` | `[]` | no |
| <a name="input_glue_trigger_description"></a> [glue\_trigger\_description](#input\_glue\_trigger\_description) | (Optional) A description of the new trigger. | `string` | `null` | no |
| <a name="input_glue_trigger_enabled"></a> [glue\_trigger\_enabled](#input\_glue\_trigger\_enabled) | (Optional) Start the trigger. Defaults to true. Not valid to disable for ON\_DEMAND type. | `bool` | `null` | no |
| <a name="input_glue_trigger_name"></a> [glue\_trigger\_name](#input\_glue\_trigger\_name) | The name of the trigger. | `string` | `""` | no |
| <a name="input_glue_trigger_predicate"></a> [glue\_trigger\_predicate](#input\_glue\_trigger\_predicate) | (Optional) A predicate to specify when the new trigger should fire. Required when trigger type is CONDITIONAL | `map` | `{}` | no |
| <a name="input_glue_trigger_schedule"></a> [glue\_trigger\_schedule](#input\_glue\_trigger\_schedule) | (Optional) A cron expression used to specify the schedule. Time-Based Schedules for Jobs and Crawlers | `string` | `null` | no |
| <a name="input_glue_trigger_timeouts"></a> [glue\_trigger\_timeouts](#input\_glue\_trigger\_timeouts) | Set timeouts for glue trigger | `map(any)` | `{}` | no |
| <a name="input_glue_trigger_type"></a> [glue\_trigger\_type](#input\_glue\_trigger\_type) | (Required) The type of trigger. Valid values are CONDITIONAL, ON\_DEMAND, and SCHEDULED. | `string` | `"ON_DEMAND"` | no |
| <a name="input_glue_trigger_workflow_name"></a> [glue\_trigger\_workflow\_name](#input\_glue\_trigger\_workflow\_name) | (Optional) A workflow to which the trigger should be associated to. Every workflow graph (DAG) needs a starting trigger (ON\_DEMAND or SCHEDULED type) and can contain multiple additional CONDITIONAL triggers. | `string` | `null` | no |
| <a name="input_glue_user_defined_function_catalog_id"></a> [glue\_user\_defined\_function\_catalog\_id](#input\_glue\_user\_defined\_function\_catalog\_id) | (Optional) ID of the Glue Catalog to create the function in. If omitted, this defaults to the AWS Account ID. | `any` | `null` | no |
| <a name="input_glue_user_defined_function_class_name"></a> [glue\_user\_defined\_function\_class\_name](#input\_glue\_user\_defined\_function\_class\_name) | (Required) The Java class that contains the function code. | `any` | `null` | no |
| <a name="input_glue_user_defined_function_database_name"></a> [glue\_user\_defined\_function\_database\_name](#input\_glue\_user\_defined\_function\_database\_name) | The name of the Database to create the Function. | `string` | `""` | no |
| <a name="input_glue_user_defined_function_name"></a> [glue\_user\_defined\_function\_name](#input\_glue\_user\_defined\_function\_name) | The name of the function. | `string` | `""` | no |
| <a name="input_glue_user_defined_function_owner_name"></a> [glue\_user\_defined\_function\_owner\_name](#input\_glue\_user\_defined\_function\_owner\_name) | (Required) The owner of the function. | `any` | `null` | no |
| <a name="input_glue_user_defined_function_owner_type"></a> [glue\_user\_defined\_function\_owner\_type](#input\_glue\_user\_defined\_function\_owner\_type) | (Required) The owner type. can be one of USER, ROLE, and GROUP. | `any` | `null` | no |
| <a name="input_glue_user_defined_function_resource_uris"></a> [glue\_user\_defined\_function\_resource\_uris](#input\_glue\_user\_defined\_function\_resource\_uris) | (Optional) The configuration block for Resource URIs. See resource uris below for more details. | `list` | `[]` | no |
| <a name="input_glue_workflow_default_run_properties"></a> [glue\_workflow\_default\_run\_properties](#input\_glue\_workflow\_default\_run\_properties) | (Optional) A map of default run properties for this workflow. These properties are passed to all jobs associated to the workflow. | `map(any)` | `null` | no |
| <a name="input_glue_workflow_description"></a> [glue\_workflow\_description](#input\_glue\_workflow\_description) | (Optional) Description of the workflow. | `string` | `null` | no |
| <a name="input_glue_workflow_name"></a> [glue\_workflow\_name](#input\_glue\_workflow\_name) | The name you assign to this workflow. | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to be used on all resources as prefix | `string` | `"hle"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A list of tag blocks. Each element should have keys named key, value, etc. | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
