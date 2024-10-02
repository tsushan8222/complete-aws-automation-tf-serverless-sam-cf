output "arn" {
  description = "Amazon Resource Name (ARN) of the domain"
  value       = join("", aws_elasticsearch_domain.es_domain.*.arn)
}

output "domain_id" {
  description = "Unique identifier for the domain"
  value       = join("", aws_elasticsearch_domain.es_domain.*.domain_id)
}

output "endpoint" {
  description = "Domain-specific endpoint used to submit index, search, and data upload requests"
  value       = join("", aws_elasticsearch_domain.es_domain.*.endpoint)
}

output "kibana_endpoint" {
  description = "Domain-specific endpoint for kibana without https scheme"
  value       = join("", aws_elasticsearch_domain.es_domain.*.kibana_endpoint)
}

output "vpc_options_availability_zones" {
  description = "If the domain was created inside a VPC, the names of the availability zones the configured subnet_ids were created inside"
  value       = var.enabled ? (length(aws_elasticsearch_domain.es_domain[0].vpc_options) > 0 ? aws_elasticsearch_domain.es_domain[0].vpc_options.0.availability_zones : []) : []
}

output "vpc_options_vpc_id" {
  description = "If the domain was created inside a VPC, the ID of the VPC"
  value       = var.enabled ? length(aws_elasticsearch_domain.es_domain[0].vpc_options) > 0 ? aws_elasticsearch_domain.es_domain[0].vpc_options.0.vpc_id : null : null
}
output "custom_domain_endpoint" {
  description = "Custom Domain Endpoint"
  value       = var.domain_endpoint_options_custom_endpoint_enabled ? join("", aws_route53_record.es_domain_mapping.*.name) : null
}

output "es_http_read_only" {
  description = "Read Only Role for lambda on Elastic Search Cluster"
  value       = aws_iam_role.read_only.arn
}

output "es_http_full_access" {
  description = "Read Only Role for lambda on Elastic Search Cluster"
  value       = aws_iam_role.es_http_full_access.arn
}

output "es_full_access" {
  description = "Read Only Role for lambda on Elastic Search Cluster"
  value       = aws_iam_role.es_full_access.arn
}
