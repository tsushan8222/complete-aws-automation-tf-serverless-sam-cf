resource "aws_route53_record" "domain_mapping" {
  count   = var.custom_domain_name != null ? 1 : 0
  zone_id = var.route_53_hosted_zone_id
  name    = var.custom_domain_name
  type    = "CNAME"
  ttl     = "300"
  records = [var.cluster_mode_enabled ? aws_elasticache_replication_group.redis.configuration_endpoint_address : aws_elasticache_replication_group.redis.primary_endpoint_address]
}
