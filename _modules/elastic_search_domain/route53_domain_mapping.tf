resource "aws_route53_record" "es_domain_mapping" {
  count   = var.domain_endpoint_options_custom_endpoint_enabled ? 1 : 0
  zone_id = var.route_53_hosted_zone_id
  name    = var.domain_endpoint_options_custom_endpoint
  type    = "CNAME"
  ttl     = "300"
  records = [join("", aws_elasticsearch_domain.es_domain.*.endpoint)]
}
