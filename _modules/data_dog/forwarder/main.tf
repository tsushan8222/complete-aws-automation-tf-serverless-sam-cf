resource "aws_cloudformation_stack" "datadog_forwarder" {
  name         = var.dd_forwarder_stack_name
  capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM", "CAPABILITY_AUTO_EXPAND"]
  parameters = {
    DdApiKeySecretArn = var.dd_api_secret_manager_arn
    DdSite            = var.dd_site
    # Lambda Function
    FunctionName        = var.dd_forwarder_lambda_function_name
    MemorySize          = var.memory_size
    Timeout             = var.timeout
    ReservedConcurrency = var.reserved_concurrency
    LogRetentionInDays  = var.log_retention_in_days
    # Log Forwarding (optional)
    DdTags                     = var.dd_tags
    DdMultilineLogRegexPattern = var.dd_multiline_log_regex_pattern
    DdUseTcp                   = var.dd_use_tcp
    DdNoSsl                    = var.dd_no_ssl
    DdUrl                      = var.dd_url
    DdPort                     = var.dd_port
    DdSkipSslValidation        = var.dd_skip_ssl_validation
    DdUseCompression           = var.dd_use_compression
    DdCompressionLevel         = var.dd_compression_level
    DdForwardLog               = var.dd_forward_log
    DdFetchLambdaTags          = var.dd_fetch_lambda_tags
    # Log Scrubbing
    RedactIp                   = var.redact_ip
    RedactEmail                = var.redact_email
    DdScrubbingRule            = var.dd_scrubbing_rule
    DdScrubbingRuleReplacement = var.dd_scrubbing_rule_replacement
    # Log Filtering
    ExcludeAtMatch = var.exclude_at_match
    IncludeAtMatch = var.include_at_match
    # Advance
    SourceZipUrl               = var.source_zip_url
    PermissionsBoundaryArn     = var.permission_boundary_arn
    DdUsePrivateLink           = var.dd_use_private_link
    DdHttpProxyURL             = var.dd_http_proxy_url
    DdNoProxy                  = var.dd_no_proxy
    VPCSecurityGroupIds        = var.vpc_security_group_ids
    VPCSubnetIds               = var.vpc_subnet_ids
    AdditionalTargetLambdaArns = var.additional_target_lambda_arns
    InstallAsLayer             = var.install_as_layer
    LayerARN                   = var.layer_arn

  }
  template_url = "https://datadog-cloudformation-template.s3.amazonaws.com/aws/forwarder/${var.dd_forwarder_template_version}.yaml"

  tags = merge(var.tags, local.default_tags)

  on_failure = "DELETE"
}
