resource "aws_elasticache_replication_group" "redis" {
  engine = "redis"

  parameter_group_name  = aws_elasticache_parameter_group.redis.name
  subnet_group_name     = aws_elasticache_subnet_group.redis.name
  security_group_ids    = concat(var.security_group_ids, [aws_security_group.redis.id])
  replication_group_id  = "${var.cluster_name}-redis"
  number_cache_clusters = var.cluster_mode_enabled ? null : var.number_cache_clusters
  node_type             = var.node_type

  engine_version = var.engine_version
  port           = var.port

  maintenance_window         = var.maintenance_window
  snapshot_window            = var.snapshot_window
  snapshot_retention_limit   = var.snapshot_retention_limit
  final_snapshot_identifier  = "${var.env}-${var.cluster_name}-redis-snapshot-${random_id.redis_pg.hex}"
  automatic_failover_enabled = var.automatic_failover_enabled && var.number_cache_clusters > 1 ? true : false
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  multi_az_enabled           = var.multi_az_enabled

  at_rest_encryption_enabled = var.at_rest_encryption_enabled
  transit_encryption_enabled = var.transit_encryption_enabled
  auth_token                 = var.auth_token != "" ? var.auth_token : null
  kms_key_id                 = var.kms_key_id

  apply_immediately = var.apply_immediately

  replication_group_description = var.description

  notification_topic_arn = var.notification_topic_arn

  dynamic "cluster_mode" {
    for_each = var.cluster_mode_enabled ? [1] : []
    content {
      replicas_per_node_group = var.replicas_per_node_group
      num_node_groups         = var.num_node_groups
    }
  }

  tags = merge(
    {
      "Name" = "${var.env}-${var.cluster_name}",
      "ENV"  = var.env
    },
    var.tags,
  )
}

resource "aws_elasticache_parameter_group" "redis" {
  name        = "${var.env}-${var.cluster_name}"
  family      = var.family
  description = var.description

  dynamic "parameter" {
    for_each = var.cluster_mode_enabled ? concat([{ name = "cluster-enabled", value = "yes" }], var.parameter) : var.parameter
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    {
      "Name" = "${var.env}-${var.cluster_name}-pg",
      "ENV"  = var.env
    },
    var.tags,
  )
}

resource "aws_elasticache_subnet_group" "redis" {
  name        = "${var.env}-${var.cluster_name}-redis-subnet-grp"
  subnet_ids  = local.vpc_subnet_ids
  description = var.description

  tags = merge(
    {
      "Name" = "${var.env}-${var.cluster_name}-redis-subnet-grp",
      "ENV"  = var.env
    },
    var.tags,
  )
}

resource "aws_security_group" "redis" {
  name   = "${var.env}-${var.cluster_name}-redis-sg"
  vpc_id = data.aws_vpc.selected.id

  tags = merge(
    {
      "Name" = "${var.env}-${var.cluster_name}-sg",
      "ENV"  = var.env
    },
    var.tags,
  )
}

resource "aws_security_group_rule" "redis_ingress_self" {
  count = var.ingress_self ? 1 : 0

  type              = "ingress"
  from_port         = var.port
  to_port           = var.port
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.redis.id
}

resource "aws_security_group_rule" "redis_ingress_cidr_blocks" {
  type              = "ingress"
  from_port         = var.port
  to_port           = var.port
  protocol          = "tcp"
  cidr_blocks       = local.vpc_cidr
  security_group_id = aws_security_group.redis.id
}

resource "aws_security_group_rule" "redis_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.redis.id
}
