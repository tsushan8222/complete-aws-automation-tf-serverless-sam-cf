#-----------------------------------------------------------
# Global or/and default variables
#-----------------------------------------------------------
variable "name" {
  type        = string
  description = "Name to be used on all resources as prefix"
  default     = "hle"
}

variable "env" {
  type        = string
  description = "Environment to apply resources on"
  default     = "dev"
}

variable "tags" {
  description = "A list of tag blocks. Each element should have keys named key, value, etc."
  type        = map(string)
  default     = {}
}

#-----------------------------------------------------------
# Athena DataBase
#-----------------------------------------------------------
variable "enable_athena_database" {
  description = "Enable Athena database usage"
  default     = false
  type        = bool
}

variable "athena_database_bucket_name" {
  description = "(Required) Name of S3 bucket to save the results of the query execution."
  type        = string
  default     = null
}
variable "athena_database_name" {
  description = "(Required) Name of the database to create."
  type        = string
  default     = null
}
variable "athena_acl_configuration" {
  description = "(Optional) Indicates that an Amazon S3 canned ACL should be set to control ownership of stored query results"
  type        = map(any)
  default     = { "s3_acl_option" : "BUCKET_OWNER_FULL_CONTROL" }
}
variable "athena_encryption_configuration" {
  description = "(Optional) The encryption key block AWS Athena uses to decrypt the data in S3, such as an AWS Key Management Service (AWS KMS) key"
  type        = map(any)
  default     = {}
}
variable "athena_properties" {
  description = "(Optional) A key-value map of custom metadata properties for the database definition."
  type        = map(any)
  default     = {}
}
variable "athena_database_force_destroy" {
  description = "(Optional, Default: true) A boolean that indicates all tables should be deleted from the database so that the database can be destroyed without error. The tables are not recoverable."
  type        = bool
  default     = true
}

#-----------------------------------------------------------
# Athena DataCatalog
#-----------------------------------------------------------
variable "enable_athena_catalog" {
  description = "Enable Athena catalog usage"
  default     = false
  type        = bool
}

variable "athena_catalog_name" {
  description = "(Required) The name of the data catalog. The catalog name must be unique for the AWS account and can use a maximum of 128 alphanumeric, underscore, at sign, or hyphen characters."
  type        = string
  default     = null
}
variable "athena_catalog_type" {
  description = " (Required) The type of data catalog: LAMBDA for a federated catalog, GLUE for AWS Glue Catalog, or HIVE for an external hive metastore."
  type        = string
  default     = "LAMBDA"
}
variable "athena_catalog_parameters" {
  description = "(Required) Key value pairs that specifies the Lambda function or functions to use for the data catalog. The mapping used depends on the catalog type."
  type        = map(any)
  default     = {}
}

#-----------------------------------------------------------
# Athena Workgroup
#-----------------------------------------------------------
variable "enable_athena_workgroup" {
  description = "Enable Athena WorkGroup usage"
  default     = false
  type        = bool
}

variable "athena_workgroup_name" {
  description = "(Required) Name of the workgroup."
  type        = string
  default     = null
}

#-----------------------------------------------------------
# Athena Named Queries
#-----------------------------------------------------------
variable "enable_athena_named_query" {
  description = "Enable Athena Named Query usage"
  default     = false
  type        = bool
}
variable "athena_named_queries" {
  description = "List of Named Queries [ {query_name: 'query name', query: 'QUERY'}]"
  default     = []
  type        = list(any)
}
