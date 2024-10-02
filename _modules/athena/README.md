# Provisions Athena Database, Quey , DataCatalog & Query


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
| [aws_athena_data_catalog.this](https://registry.terraform.io/providers/hashicorp/aws/4.17.1/docs/resources/athena_data_catalog) | resource |
| [aws_athena_database.this](https://registry.terraform.io/providers/hashicorp/aws/4.17.1/docs/resources/athena_database) | resource |
| [aws_athena_named_query.this](https://registry.terraform.io/providers/hashicorp/aws/4.17.1/docs/resources/athena_named_query) | resource |
| [aws_athena_workgroup.this](https://registry.terraform.io/providers/hashicorp/aws/4.17.1/docs/resources/athena_workgroup) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_athena_acl_configuration"></a> [athena\_acl\_configuration](#input\_athena\_acl\_configuration) | (Optional) Indicates that an Amazon S3 canned ACL should be set to control ownership of stored query results | `map(any)` | <pre>{<br>  "s3_acl_option": "BUCKET_OWNER_FULL_CONTROL"<br>}</pre> | no |
| <a name="input_athena_catalog_name"></a> [athena\_catalog\_name](#input\_athena\_catalog\_name) | (Required) The name of the data catalog. The catalog name must be unique for the AWS account and can use a maximum of 128 alphanumeric, underscore, at sign, or hyphen characters. | `string` | `null` | no |
| <a name="input_athena_catalog_parameters"></a> [athena\_catalog\_parameters](#input\_athena\_catalog\_parameters) | (Required) Key value pairs that specifies the Lambda function or functions to use for the data catalog. The mapping used depends on the catalog type. | `map(any)` | `{}` | no |
| <a name="input_athena_catalog_type"></a> [athena\_catalog\_type](#input\_athena\_catalog\_type) | (Required) The type of data catalog: LAMBDA for a federated catalog, GLUE for AWS Glue Catalog, or HIVE for an external hive metastore. | `string` | `"LAMBDA"` | no |
| <a name="input_athena_database_bucket_name"></a> [athena\_database\_bucket\_name](#input\_athena\_database\_bucket\_name) | (Required) Name of S3 bucket to save the results of the query execution. | `string` | `null` | no |
| <a name="input_athena_database_force_destroy"></a> [athena\_database\_force\_destroy](#input\_athena\_database\_force\_destroy) | (Optional, Default: true) A boolean that indicates all tables should be deleted from the database so that the database can be destroyed without error. The tables are not recoverable. | `bool` | `true` | no |
| <a name="input_athena_database_name"></a> [athena\_database\_name](#input\_athena\_database\_name) | (Required) Name of the database to create. | `string` | `null` | no |
| <a name="input_athena_encryption_configuration"></a> [athena\_encryption\_configuration](#input\_athena\_encryption\_configuration) | (Optional) The encryption key block AWS Athena uses to decrypt the data in S3, such as an AWS Key Management Service (AWS KMS) key | `map(any)` | `{}` | no |
| <a name="input_athena_named_queries"></a> [athena\_named\_queries](#input\_athena\_named\_queries) | List of Named Queries [ {query\_name: 'query name', query: 'QUERY'}] | `list(any)` | `[]` | no |
| <a name="input_athena_properties"></a> [athena\_properties](#input\_athena\_properties) | (Optional) A key-value map of custom metadata properties for the database definition. | `map(any)` | `{}` | no |
| <a name="input_athena_workgroup_name"></a> [athena\_workgroup\_name](#input\_athena\_workgroup\_name) | (Required) Name of the workgroup. | `string` | `null` | no |
| <a name="input_enable_athena_catalog"></a> [enable\_athena\_catalog](#input\_enable\_athena\_catalog) | Enable Athena catalog usage | `bool` | `false` | no |
| <a name="input_enable_athena_database"></a> [enable\_athena\_database](#input\_enable\_athena\_database) | Enable Athena database usage | `bool` | `false` | no |
| <a name="input_enable_athena_named_query"></a> [enable\_athena\_named\_query](#input\_enable\_athena\_named\_query) | Enable Athena Named Query usage | `bool` | `false` | no |
| <a name="input_enable_athena_workgroup"></a> [enable\_athena\_workgroup](#input\_enable\_athena\_workgroup) | Enable Athena WorkGroup usage | `bool` | `false` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment to apply resources on | `string` | `"dev"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to be used on all resources as prefix | `string` | `"hle"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A list of tag blocks. Each element should have keys named key, value, etc. | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
