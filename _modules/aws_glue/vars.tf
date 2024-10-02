#-----------------------------------------------------------
# Global or/and default variables
#-----------------------------------------------------------
variable "name" {
  type        = string
  description = "Name to be used on all resources as prefix"
  default     = "hle"
}

variable "environment" {
  type        = string
  description = "Environment to apply resources on"
  default     = "dev"
}

variable "tags" {
  description = "A list of tag blocks. Each element should have keys named key, value, etc."
  type        = map(string)
  default     = {}
}

#---------------------------------------------------
# AWS Glue catalog database
#---------------------------------------------------
variable "enable_glue_catalog_database" {
  description = "Enable glue catalog database usage"
  default     = false
  type        = bool
}

variable "glue_catalog_database_name" {
  description = "The name of the database."
  default     = ""
  type        = string
}

variable "glue_catalog_database_description" {
  description = "(Optional) Description of the database."
  default     = null
  type        = string
}

variable "glue_catalog_database_catalog_id" {
  description = "(Optional) ID of the Glue Catalog to create the database in. If omitted, this defaults to the AWS Account ID."
  default     = null
  type        = string
}

variable "glue_catalog_database_location_uri" {
  description = "(Optional) The location of the database (for example, an HDFS path)."
  default     = null
  type        = string
}

variable "glue_catalog_database_parameters" {
  description = "(Optional) A list of key-value pairs that define parameters and properties of the database."
  default     = null
  type        = map(any)
}

#---------------------------------------------------
# AWS Glue catalog table
#---------------------------------------------------
variable "enable_glue_catalog_table" {
  description = "Enable glue catalog table usage"
  default     = false
  type        = bool
}


variable "glue_catalog_databases_config" {
  type        = list(any)
  default     = []
  description = "list of Glue Catalog Configurations"
}

#---------------------------------------------------
# AWS Glue classifier
#---------------------------------------------------
variable "enable_glue_classifier" {
  description = "Enable glue classifier usage"
  default     = false
  type        = bool
}

variable "glue_classifier_name" {
  description = "The name of the classifier."
  default     = ""
  type        = string
}

variable "glue_classifier_csv_classifier" {
  description = "(Optional) A classifier for Csv content. "
  default     = []
  type        = list(any)
}

variable "glue_classifier_grok_classifier" {
  description = "(Optional) A classifier for grok content. "
  default     = []
  type        = list(any)
}

variable "glue_classifier_json_classifier" {
  description = "(Optional) A classifier for json content. "
  default     = []
  type        = list(any)
}

variable "glue_classifier_xml_classifier" {
  description = "(Optional) A classifier for xml content. "
  default     = []
  type        = list(any)
}

#---------------------------------------------------
# AWS Glue connection
#---------------------------------------------------

variable "aws_glue_connections" {
  description = "(Optional) List of AWS Glue Connection configurations "
  type        = list(any)
  default     = []
}


#---------------------------------------------------
# AWS Glue crawler
#---------------------------------------------------
variable "enable_glue_crawler" {
  description = "Enable glue crawler usage"
  default     = false
  type        = bool
}
variable "glue_crawlers" {
  description = "List Of Glue Crawlers Configurations"
  type        = list(any)
  default     = []
}

#---------------------------------------------------
# AWS glue security configuration
#---------------------------------------------------
variable "enable_glue_security_configuration" {
  description = "Enable glue security configuration usage"
  default     = false
  type        = bool
}

variable "glue_security_configuration_name" {
  description = "Name of the security configuration."
  default     = ""
  type        = string
}

variable "glue_security_configuration_encryption_configuration" {
  description = "Set encryption configuration for Glue security configuration"
  default     = {}
  type        = map(any)
}


#---------------------------------------------------
# AWS Glue data catalog encryption settings
#---------------------------------------------------
variable "enable_glue_data_catalog_encryption_settings" {
  description = "Enable glue data catalog encryption settings usage"
  default     = false
  type        = bool
}

variable "glue_data_catalog_encryption_settings_data_catalog_encryption_settings" {
  description = "Set data_catalog_encryption_settings block for Glue data catalog encryption"
  default     = {}
  type        = map(any)
}

variable "glue_data_catalog_encryption_settings_catalog_id" {
  description = "(Optional) The ID of the Data Catalog to set the security configuration for. If none is provided, the AWS account ID is used by default."
  default     = null
  type        = string
}

#---------------------------------------------------
# AWS Glue workflow
#---------------------------------------------------
variable "enable_glue_workflow" {
  description = "Enable glue workflow usage"
  default     = false
  type        = bool
}

variable "glue_workflow_name" {
  description = "The name you assign to this workflow."
  default     = ""
  type        = string
}

variable "glue_workflow_description" {
  description = "(Optional) Description of the workflow."
  default     = null
  type        = string
}

variable "glue_workflow_default_run_properties" {
  description = "(Optional) A map of default run properties for this workflow. These properties are passed to all jobs associated to the workflow."
  default     = null
  type        = map(any)
}

#---------------------------------------------------
# AWS Glue job
#---------------------------------------------------
variable "enable_glue_job" {
  description = "Enable glue job usage"
  default     = false
  type        = bool
}

variable "glue_job_name" {
  description = "The name you assign to this job. It must be unique in your account."
  default     = ""
  type        = string
}

variable "glue_job_role_arn" {
  description = "The ARN of the IAM role associated with this job."
  default     = null
  type        = string
}

variable "glue_job_command" {
  description = "(Required) The command of the job."
  default     = []
  type        = list(any)
}

variable "glue_job_description" {
  description = "(Optional) Description of the job."
  default     = null
  type        = string
}

variable "glue_job_connections" {
  description = "(Optional) The list of connections used for this job."
  default     = []
  type        = list(any)
}

variable "glue_job_additional_connections" {
  description = "(Optional) The list of connections used for the job."
  default     = []
  type        = list(any)
}

variable "glue_job_default_arguments" {
  description = "(Optional) The map of default arguments for this job. You can specify arguments here that your own job-execution script consumes, as well as arguments that AWS Glue itself consumes. For information about how to specify and consume your own Job arguments, see the Calling AWS Glue APIs in Python topic in the developer guide. For information about the key-value pairs that AWS Glue consumes to set up your job, see the Special Parameters Used by AWS Glue topic in the developer guide."
  default = {
    "--job-language" = "python"
  }
  type = map(any)
}

variable "glue_job_execution_property" {
  description = "(Optional) Execution property of the job."
  default     = []
  type        = list(any)
}

variable "glue_job_glue_version" {
  description = "(Optional) The version of glue to use, for example '1.0'. For information about available versions, see the AWS Glue Release Notes."
  default     = null
  type        = string
}

variable "glue_job_max_capacity" {
  description = "(Optional) The maximum number of AWS Glue data processing units (DPUs) that can be allocated when this job runs. Required when pythonshell is set, accept either 0.0625 or 1.0."
  default     = null
  type        = string
}

variable "glue_job_max_retries" {
  description = "(Optional) The maximum number of times to retry this job if it fails."
  default     = null
  type        = string
}

variable "glue_job_notification_property" {
  description = "(Optional) Notification property of the job."
  default     = []
  type        = list(any)
}

variable "glue_job_timeout" {
  description = "(Optional) The job timeout in minutes. The default is 2880 minutes (48 hours)."
  default     = 2880
  type        = number
}

variable "glue_job_security_configuration" {
  description = "(Optional) The name of the Security Configuration to be associated with the job."
  default     = null
  type        = string
}

variable "glue_job_worker_type" {
  description = "(Optional) The type of predefined worker that is allocated when a job runs. Accepts a value of Standard, G.1X, or G.2X."
  default     = null
  type        = string
}

variable "glue_job_number_of_workers" {
  description = "(Optional) The number of workers of a defined workerType that are allocated when a job runs."
  default     = null
  type        = number
}

#---------------------------------------------------
# AWS Glue trigger
#---------------------------------------------------
variable "enable_glue_trigger" {
  description = "Enable glue trigger usage"
  default     = false
  type        = bool
}

variable "glue_trigger_name" {
  description = "The name of the trigger."
  default     = ""
  type        = string
}

variable "glue_trigger_type" {
  description = "(Required) The type of trigger. Valid values are CONDITIONAL, ON_DEMAND, and SCHEDULED."
  default     = "ON_DEMAND"
  type        = string
}

variable "glue_trigger_description" {
  description = "(Optional) A description of the new trigger."
  default     = null
  type        = string
}

variable "glue_trigger_enabled" {
  description = "(Optional) Start the trigger. Defaults to true. Not valid to disable for ON_DEMAND type."
  default     = null
  type        = bool
}

variable "glue_trigger_schedule" {
  description = "(Optional) A cron expression used to specify the schedule. Time-Based Schedules for Jobs and Crawlers"
  default     = null
  type        = string
}

variable "glue_trigger_workflow_name" {
  description = "(Optional) A workflow to which the trigger should be associated to. Every workflow graph (DAG) needs a starting trigger (ON_DEMAND or SCHEDULED type) and can contain multiple additional CONDITIONAL triggers."
  default     = null
  type        = string
}

variable "glue_trigger_actions" {
  description = "(Required) List of actions initiated by this trigger when it fires. "
  default     = []
  type        = list(any)
}

variable "glue_trigger_timeouts" {
  description = "Set timeouts for glue trigger"
  default     = {}
  type        = map(any)
}

variable "glue_trigger_predicate" {
  description = "(Optional) A predicate to specify when the new trigger should fire. Required when trigger type is CONDITIONAL"
  default     = {}
}


#---------------------------------------------------
# AWS Glue dev endpoint
#---------------------------------------------------
variable "enable_glue_dev_endpoint" {
  description = "Enable glue dev endpoint usage"
  default     = false
  type        = bool
}

variable "glue_dev_endpoint_name" {
  description = "The name of this endpoint. It must be unique in your account."
  default     = ""
  type        = string
}

variable "glue_dev_endpoint_role_arn" {
  description = "(Required) The IAM role for this endpoint."
  default     = null
  type        = string
}

variable "glue_dev_endpoint_arguments" {
  description = "(Optional) A map of arguments used to configure the endpoint."
  default     = null
  type        = map(any)
}

variable "glue_dev_endpoint_extra_jars_s3_path" {
  description = "(Optional) Path to one or more Java Jars in an S3 bucket that should be loaded in this endpoint."
  default     = null
}

variable "glue_dev_endpoint_extra_python_libs_s3_path" {
  description = "(Optional) Path(s) to one or more Python libraries in an S3 bucket that should be loaded in this endpoint. Multiple values must be complete paths separated by a comma."
  default     = null
}

variable "glue_dev_endpoint_glue_version" {
  description = "(Optional) - Specifies the versions of Python and Apache Spark to use. Defaults to AWS Glue version 0.9."
  default     = null
}

variable "glue_dev_endpoint_number_of_nodes" {
  description = "(Optional) The number of AWS Glue Data Processing Units (DPUs) to allocate to this endpoint. Conflicts with worker_type"
  default     = null
}

variable "glue_dev_endpoint_number_of_workers" {
  description = "(Optional) The number of workers of a defined worker type that are allocated to this endpoint. This field is available only when you choose worker type G.1X or G.2X."
  default     = null
}

variable "glue_dev_endpoint_public_key" {
  description = "(Optional) The public key to be used by this endpoint for authentication."
  default     = null
}

variable "glue_dev_endpoint_public_keys" {
  description = "(Optional) A list of public keys to be used by this endpoint for authentication."
  default     = null
}

variable "glue_dev_endpoint_security_configuration" {
  description = "(Optional) The name of the Security Configuration structure to be used with this endpoint."
  default     = null
}

variable "glue_dev_endpoint_security_group_ids" {
  description = "(Optional) Security group IDs for the security groups to be used by this endpoint."
  default     = null
}

variable "glue_dev_endpoint_subnet_id" {
  description = "(Optional) The subnet ID for the new endpoint to use."
  default     = null
}

variable "glue_dev_endpoint_worker_type" {
  description = "(Optional) The type of predefined worker that is allocated to this endpoint. Accepts a value of Standard, G.1X, or G.2X."
  default     = null
}

#---------------------------------------------------
# AWS Glue ml transform
#---------------------------------------------------
variable "enable_glue_ml_transform" {
  description = "Enable glue ml transform usage"
  default     = false
}

variable "glue_ml_transform_name" {
  description = "The name you assign to this ML Transform. It must be unique in your account."
  default     = ""
}

variable "glue_ml_transform_role_arn" {
  description = "(Required) The ARN of the IAM role associated with this ML Transform."
  default     = null
}

variable "glue_ml_transform_input_record_tables" {
  description = "(Required) A list of AWS Glue table definitions used by the transform. see Input Record Tables."
  default     = []
}

variable "glue_ml_transform_parameters" {
  description = "(Required) The algorithmic parameters that are specific to the transform type used. Conditionally dependent on the transform type. see Parameters."
  default     = []
}

variable "glue_ml_transform_description" {
  description = "(Optional) Description of the ML Transform."
  default     = null
}

variable "glue_ml_transform_glue_version" {
  description = "(Optional) The version of glue to use, for example '1.0'. For information about available versions, see the AWS Glue Release Notes."
  default     = null
}

variable "glue_ml_transform_max_capacity" {
  description = "(Optional) The number of AWS Glue data processing units (DPUs) that are allocated to task runs for this transform. You can allocate from 2 to 100 DPUs; the default is 10. max_capacity is a mutually exclusive option with number_of_workers and worker_type."
  default     = null
}

variable "glue_ml_transform_max_retries" {
  description = "(Optional) The maximum number of times to retry this ML Transform if it fails."
  default     = null
}

variable "glue_ml_transform_timeout" {
  description = "(Optional) The ML Transform timeout in minutes. The default is 2880 minutes (48 hours)."
  default     = null
}

variable "glue_ml_transform_worker_type" {
  description = "(Optional) The type of predefined worker that is allocated when an ML Transform runs. Accepts a value of Standard, G.1X, or G.2X. Required with number_of_workers."
  default     = null
}

variable "glue_ml_transform_number_of_workers" {
  description = "(Optional) The number of workers of a defined worker_type that are allocated when an ML Transform runs. Required with worker_type"
  default     = null
}


#---------------------------------------------------
# AWS Glue partition
#---------------------------------------------------
variable "enable_glue_partition" {
  description = "Enable glue partition usage"
  default     = false
}

variable "glue_partition_database_name" {
  description = "Name of the metadata database where the table metadata resides. For Hive compatibility, this must be all lowercase."
  default     = ""
}

variable "glue_partition_table_name" {
  description = "Table name"
  default     = ""
}

variable "glue_partition_partition_values" {
  description = "(Required) The values that define the partition."
  default     = []
}

variable "glue_partition_catalog_id" {
  description = "(Optional) ID of the Glue Catalog and database to create the table in. If omitted, this defaults to the AWS Account ID plus the database name."
  default     = null
  type        = string
}

variable "glue_partition_parameters" {
  description = "(Optional) Properties associated with this table, as a list of key-value pairs."
  default     = null
  type        = map(any)
}

variable "glue_partition_storage_descriptor" {
  description = "(Optional) A storage descriptor object containing information about the physical storage of this table. You can refer to the Glue Developer Guide for a full explanation of this object."
  default = {
    location                  = null
    input_format              = null
    output_format             = null
    compressed                = null
    number_of_buckets         = null
    bucket_columns            = null
    parameters                = null
    stored_as_sub_directories = null
  }
  type = map(any)
}


#---------------------------------------------------
# AWS Glue registry
#---------------------------------------------------
variable "enable_glue_registry" {
  description = "Enable glue registry usage"
  default     = false
}

variable "glue_registry_name" {
  description = "The Name of the registry."
  default     = ""
}

variable "glue_registry_description" {
  description = "(Optional) A description of the registry."
  default     = null
}


#---------------------------------------------------
# AWS Glue resource policy
#---------------------------------------------------
variable "enable_glue_resource_policy" {
  description = "Enable glue resource policy usage"
  default     = false
}

variable "glue_resource_policy" {
  description = "(Required) The policy to be applied to the aws glue data catalog."
  default     = null
}


#---------------------------------------------------
# AWS Glue schema
#---------------------------------------------------
variable "enable_glue_schema" {
  description = "Enable glue schema usage"
  default     = false
}

variable "glue_schema_name" {
  description = "The Name of the schema."
  default     = ""
}

variable "glue_schema_registry_arn" {
  description = "The ARN of the Glue Registry to create the schema in."
  default     = ""
}

variable "glue_schema_data_format" {
  description = "(Required) The data format of the schema definition. Currently only AVRO is supported."
  default     = null
}

variable "glue_schema_compatibility" {
  description = "(Required) The compatibility mode of the schema. Values values are: NONE, DISABLED, BACKWARD, BACKWARD_ALL, FORWARD, FORWARD_ALL, FULL, and FULL_ALL."
  default     = null
}

variable "glue_schema_schema_definition" {
  description = "(Required) The schema definition using the data_format setting for schema_name."
  default     = null
}

variable "glue_schema_description" {
  description = "(Optional) A description of the schema."
  default     = null
}

#---------------------------------------------------
# AWS Glue user defined function
#---------------------------------------------------
variable "enable_glue_user_defined_function" {
  description = "Enable glue user defined function usage"
  default     = false
}

variable "glue_user_defined_function_name" {
  description = "The name of the function."
  default     = ""
}

variable "glue_user_defined_function_database_name" {
  description = "The name of the Database to create the Function."
  default     = ""
}

variable "glue_user_defined_function_class_name" {
  description = "(Required) The Java class that contains the function code."
  default     = null
}

variable "glue_user_defined_function_owner_name" {
  description = "(Required) The owner of the function."
  default     = null
}

variable "glue_user_defined_function_owner_type" {
  description = "(Required) The owner type. can be one of USER, ROLE, and GROUP."
  default     = null
}

variable "glue_user_defined_function_catalog_id" {
  description = "(Optional) ID of the Glue Catalog to create the function in. If omitted, this defaults to the AWS Account ID."
  default     = null
}

variable "glue_user_defined_function_resource_uris" {
  description = "(Optional) The configuration block for Resource URIs. See resource uris below for more details."
  default     = []
}
