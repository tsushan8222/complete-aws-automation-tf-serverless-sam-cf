locals {
  # advanced_security_options
  # Create subblock master_user_options
  master_user_options = lookup(var.advanced_security_options, "master_user_options", null) != null ? lookup(var.advanced_security_options, "master_user_options") : {
    master_user_arn      = var.advanced_security_options_internal_user_database_enabled == false ? var.advanced_security_options_master_user_arn : null
    master_user_name     = var.advanced_security_options_internal_user_database_enabled == true ? var.advanced_security_options_master_user_username : null
    master_user_password = var.advanced_security_options_internal_user_database_enabled == true ? var.advanced_security_options_master_user_password : null
  }

  # If advanced_security_options is provided, build an advanced_security_options using the default values
  advanced_security_options_default = {
    enabled                        = lookup(var.advanced_security_options, "enabled", null) == null ? var.advanced_security_options_enabled : lookup(var.advanced_security_options, "enabled")
    internal_user_database_enabled = lookup(var.advanced_security_options, "internal_user_database_enabled", null) == null ? var.advanced_security_options_internal_user_database_enabled : lookup(var.advanced_security_options, "internal_user_database_enabled")
    master_user_options            = local.master_user_options
  }

  advanced_security_options = lookup(local.advanced_security_options_default, "enabled", false) == false ? [] : [local.advanced_security_options_default]

  # If domain_endpoint_options is provided, build an domain_endpoint_options using the default values
  domain_endpoint_options_default = {
    enforce_https       = lookup(var.domain_endpoint_options, "enforce_https", null) == null ? var.domain_endpoint_options_enforce_https : lookup(var.domain_endpoint_options, "enforce_https")
    tls_security_policy = lookup(var.domain_endpoint_options, "tls_security_policy", null) == null ? var.domain_endpoint_options_tls_security_policy : lookup(var.domain_endpoint_options, "tls_security_policy")

    # custom_endpoint
    custom_endpoint_enabled         = lookup(var.domain_endpoint_options, "custom_endpoint_enabled", null) == null ? var.domain_endpoint_options_custom_endpoint_enabled : lookup(var.domain_endpoint_options, "custom_endpoint_enabled")
    custom_endpoint                 = lookup(var.domain_endpoint_options, "custom_endpoint", null) == null ? var.domain_endpoint_options_custom_endpoint : lookup(var.domain_endpoint_options, "custom_endpoint")
    custom_endpoint_certificate_arn = lookup(var.domain_endpoint_options, "custom_endpoint_certificate_arn", null) == null ? var.domain_endpoint_options_custom_endpoint_certificate_arn : lookup(var.domain_endpoint_options, "custom_endpoint_certificate_arn")
  }

  domain_endpoint_options = lookup(local.domain_endpoint_options_default, "enforce_https", false) == false ? [] : [local.domain_endpoint_options_default]

  # ebs_options
  # If no ebs_options is provided, build an ebs_options using the default values
  ebs_option_default = {
    ebs_enabled = lookup(var.ebs_options, "ebs_enabled", null) == null ? var.ebs_enabled : lookup(var.ebs_options, "ebs_enabled")
    volume_type = lookup(var.ebs_options, "volume_type", null) == null ? var.ebs_options_volume_type : lookup(var.ebs_options, "volume_type")
    volume_size = lookup(var.ebs_options, "volume_size", null) == null ? var.ebs_options_volume_size : lookup(var.ebs_options, "volume_size")
    iops        = lookup(var.ebs_options, "iops", null) == null ? var.ebs_options_iops : lookup(var.ebs_options, "iops")
  }

  ebs_options = var.ebs_enabled == false || lookup(local.ebs_option_default, "ebs_enabled", false) == false ? [] : [local.ebs_option_default]

  # encrypt_at_rest
  # If no encrypt_at_rest list is provided, build a encrypt_at_rest using the default values

  encrypt_at_rest_default = {
    enabled    = lookup(var.encrypt_at_rest, "enabled", null) == null ? var.encrypt_at_rest_enabled : lookup(var.encrypt_at_rest, "enabled")
    kms_key_id = lookup(var.encrypt_at_rest, "kms_key_id", null) == null ? data.aws_kms_key.aws_es.arn : lookup(var.encrypt_at_rest, "kms_key_id")
  }

  encrypt_at_rest = var.encrypt_at_rest_enabled == false || lookup(local.encrypt_at_rest_default, "enabled", false) == false ? [] : [local.encrypt_at_rest_default]

  # node_to_node_encryption
  # If no node_to_node_encryption list is provided, build a node_to_node_encryption using the default values
  node_to_node_encryption_default = {
    enabled = lookup(var.node_to_node_encryption, "enabled", null) == null ? var.node_to_node_encryption_enabled : lookup(var.node_to_node_encryption, "enabled")
  }

  node_to_node_encryption = var.node_to_node_encryption_enabled == false || lookup(local.node_to_node_encryption_default, "enabled", false) == false ? [] : [local.node_to_node_encryption_default]

  # cluster_config
  # If no cluster_config list is provided, build a cluster_config using the default values
  cluster_config_default = {
    instance_type            = lookup(var.cluster_config, "instance_type", null) == null ? var.cluster_config_instance_type : lookup(var.cluster_config, "instance_type")
    instance_count           = lookup(var.cluster_config, "instance_count", null) == null ? var.cluster_config_instance_count : lookup(var.cluster_config, "instance_count")
    dedicated_master_enabled = lookup(var.cluster_config, "dedicated_master_enabled", null) == null ? var.cluster_config_dedicated_master_enabled : lookup(var.cluster_config, "dedicated_master_enabled")
    dedicated_master_type    = lookup(var.cluster_config, "dedicated_master_type", null) == null ? var.cluster_config_dedicated_master_type : lookup(var.cluster_config, "dedicated_master_type")
    dedicated_master_count   = lookup(var.cluster_config, "dedicated_master_count", null) == null ? var.cluster_config_dedicated_master_count : lookup(var.cluster_config, "dedicated_master_count")
    zone_awareness_enabled   = lookup(var.cluster_config, "zone_awareness_enabled", null) == null ? var.cluster_config_zone_awareness_enabled : lookup(var.cluster_config, "zone_awareness_enabled")
    availability_zone_count  = lookup(var.cluster_config, "availability_zone_count", null) == null ? var.cluster_config_availability_zone_count : lookup(var.cluster_config, "availability_zone_count")
    warm_enabled             = lookup(var.cluster_config, "warm_enabled", null) == null ? var.cluster_config_warm_enabled : lookup(var.cluster_config, "warm_enabled")
    warm_count               = lookup(var.cluster_config, "warm_count", null) == null ? var.cluster_config_warm_count : lookup(var.cluster_config, "warm_count")
    warm_type                = lookup(var.cluster_config, "warm_type", null) == null ? var.cluster_config_warm_type : lookup(var.cluster_config, "warm_type")
  }

  cluster_config = [local.cluster_config_default]

  # snapshot_options
  # If no snapshot_options list is provided, build a snapshot_options using the default values
  snapshot_options_default = {
    automated_snapshot_start_hour = lookup(var.snapshot_options, "automated_snapshot_start_hour", null) == null ? var.snapshot_options_automated_snapshot_start_hour : lookup(var.snapshot_options, "automated_snapshot_start_hour")
  }

  snapshot_options = [local.snapshot_options_default]

  # vpc_options
  # If no vpc_options list is provided, build a vpc_options using the default values
  vpc_options_default = {
    security_group_ids = lookup(var.vpc_options, "security_group_ids", null) == null ? [aws_security_group.allow_tls.id] : lookup(var.vpc_options, "security_group_ids")
    subnet_ids         = lookup(var.vpc_options, "subnet_ids", null) == null ? slice(tolist(data.aws_subnet_ids.private.ids), 0, var.cluster_config_availability_zone_count) : lookup(var.vpc_options, "subnet_ids")
  }

  vpc_options = length(lookup(local.vpc_options_default, "subnet_ids")) == 0 ? [] : [local.vpc_options_default]

  # log_publishing_options
  # If no log_publishing_options list is provided, build a log_publishing_options using the default values
  log_publishing_options_default = {
    log_type                 = lookup(var.log_publishing_options, "log_type", null) == null ? var.log_publishing_options_log_type : lookup(var.log_publishing_options, "log_type")
    cloudwatch_log_group_arn = lookup(var.log_publishing_options, "cloudwatch_log_group_arn", null) == null ? (var.log_publishing_options_cloudwatch_log_group_arn == "" && var.enabled ? aws_cloudwatch_log_group.es_cloudwatch_log_group[0].arn : var.log_publishing_options_cloudwatch_log_group_arn) : lookup(var.log_publishing_options, "cloudwatch_log_group_arn")
    enabled                  = lookup(var.log_publishing_options, "enabled", null) == null ? var.log_publishing_options_enabled : lookup(var.log_publishing_options, "enabled")
  }

  log_publishing_options = var.log_publishing_options_enabled == false || lookup(local.log_publishing_options_default, "enabled") == false ? [] : [local.log_publishing_options_default]

  # cognito_options
  # If no cognito_options list is provided, build a cognito_options using the default values
  cognito_options_default = {
    enabled          = lookup(var.cognito_options, "enabled", null) == null ? var.cognito_options_enabled : lookup(var.cognito_options, "enabled")
    user_pool_id     = lookup(var.cognito_options, "user_pool_id", null) == null ? var.cognito_options_user_pool_id : lookup(var.cognito_options, "user_pool_id")
    identity_pool_id = lookup(var.cognito_options, "identity_pool_id", null) == null ? var.cognito_options_identity_pool_id : lookup(var.cognito_options, "identity_pool_id")
    role_arn         = lookup(var.cognito_options, "role_arn", null) == null ? var.cognito_options_role_arn : lookup(var.cognito_options, "role_arn")
  }

  cognito_options = var.cognito_options_enabled == false || lookup(local.cognito_options_default, "enabled", false) == false ? [] : [local.cognito_options_default]

  # Timeouts
  # If timeouts block is provided, build one using the default values
  timeouts = var.timeouts_update == null && length(var.timeouts) == 0 ? [] : [
    {
      update = lookup(var.timeouts, "update", null) == null ? var.timeouts_update : lookup(var.timeouts, "update")
    }
  ]
}
