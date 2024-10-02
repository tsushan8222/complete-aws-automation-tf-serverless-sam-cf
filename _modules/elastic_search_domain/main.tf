resource "aws_elasticsearch_domain" "es_domain" {

  count = var.enabled ? 1 : 0

  # Domain name
  domain_name = var.domain_name

  # ElasticSeach version
  elasticsearch_version = var.elasticsearch_version

  # access_policies
  access_policies = var.access_policies

  # advanced_options
  advanced_options = var.advanced_options == null ? {} : var.advanced_options

  # advanced_security_options
  dynamic "advanced_security_options" {
    for_each = local.advanced_security_options
    content {
      enabled                        = lookup(advanced_security_options.value, "enabled")
      internal_user_database_enabled = lookup(advanced_security_options.value, "internal_user_database_enabled")

      master_user_options {
        master_user_arn      = lookup(lookup(advanced_security_options.value, "master_user_options"), "master_user_arn", null)
        master_user_name     = lookup(lookup(advanced_security_options.value, "master_user_options"), "master_user_name", null)
        master_user_password = lookup(lookup(advanced_security_options.value, "master_user_options"), "master_user_password", null)
      }
    }
  }

  # domain_endpoint_options
  dynamic "domain_endpoint_options" {
    for_each = local.domain_endpoint_options
    content {
      enforce_https                   = lookup(domain_endpoint_options.value, "enforce_https")
      tls_security_policy             = lookup(domain_endpoint_options.value, "tls_security_policy")
      custom_endpoint_enabled         = lookup(domain_endpoint_options.value, "custom_endpoint_enabled")
      custom_endpoint                 = lookup(domain_endpoint_options.value, "custom_endpoint")
      custom_endpoint_certificate_arn = lookup(domain_endpoint_options.value, "custom_endpoint_certificate_arn")
    }
  }

  # ebs_options
  dynamic "ebs_options" {
    for_each = local.ebs_options
    content {
      ebs_enabled = lookup(ebs_options.value, "ebs_enabled")
      volume_type = lookup(ebs_options.value, "volume_type")
      volume_size = lookup(ebs_options.value, "volume_size")
      iops        = lookup(ebs_options.value, "iops")
    }
  }

  # encrypt_at_rest
  dynamic "encrypt_at_rest" {
    for_each = local.encrypt_at_rest
    content {
      enabled    = lookup(encrypt_at_rest.value, "enabled")
      kms_key_id = lookup(encrypt_at_rest.value, "kms_key_id")
    }
  }

  # node_to_node_encryption
  dynamic "node_to_node_encryption" {
    for_each = local.node_to_node_encryption
    content {
      enabled = lookup(node_to_node_encryption.value, "enabled")
    }
  }

  # cluster_config
  dynamic "cluster_config" {
    for_each = local.cluster_config
    content {
      instance_type            = lookup(cluster_config.value, "instance_type")
      instance_count           = lookup(cluster_config.value, "instance_count")
      dedicated_master_enabled = lookup(cluster_config.value, "dedicated_master_enabled")
      dedicated_master_type    = lookup(cluster_config.value, "dedicated_master_type")
      dedicated_master_count   = lookup(cluster_config.value, "dedicated_master_count")
      zone_awareness_enabled   = lookup(cluster_config.value, "zone_awareness_enabled")
      warm_enabled             = lookup(cluster_config.value, "warm_enabled")
      warm_count               = lookup(cluster_config.value, "warm_count")
      warm_type                = lookup(cluster_config.value, "warm_type")

      dynamic "zone_awareness_config" {
        # cluster_availability_zone_count valid values: 2 or 3.
        for_each = lookup(cluster_config.value, "zone_awareness_enabled", false) == false || !contains(["2", "3"], lookup(cluster_config.value, "availability_zone_count", "1")) ? [] : [1]
        content {
          availability_zone_count = lookup(cluster_config.value, "availability_zone_count")
        }
      }
    }
  }

  # snapshot_options
  dynamic "snapshot_options" {
    for_each = local.snapshot_options
    content {
      automated_snapshot_start_hour = lookup(snapshot_options.value, "automated_snapshot_start_hour")
    }
  }

  # vpc_options
  dynamic "vpc_options" {
    for_each = local.vpc_options
    content {
      security_group_ids = lookup(vpc_options.value, "security_group_ids")
      subnet_ids         = lookup(vpc_options.value, "subnet_ids")
    }
  }

  # log_publishing_options
  dynamic "log_publishing_options" {
    for_each = local.log_publishing_options
    content {
      log_type                 = lookup(log_publishing_options.value, "log_type")
      cloudwatch_log_group_arn = lookup(log_publishing_options.value, "cloudwatch_log_group_arn")
      enabled                  = lookup(log_publishing_options.value, "enabled")
    }
  }

  # cognito_options
  dynamic "cognito_options" {
    for_each = local.cognito_options
    content {
      enabled          = lookup(cognito_options.value, "enabled")
      user_pool_id     = lookup(cognito_options.value, "user_pool_id")
      identity_pool_id = lookup(cognito_options.value, "identity_pool_id")
      role_arn         = lookup(cognito_options.value, "role_arn")
    }
  }

  # Timeouts
  dynamic "timeouts" {
    for_each = local.timeouts
    content {
      update = lookup(timeouts.value, "update")
    }
  }

  # Tags
  tags = var.tags

  # Service-linked role to give Amazon ES permissions to access your VPC
  depends_on = [
    aws_iam_service_linked_role.es,
  ]

}
