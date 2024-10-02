include {
  path = find_in_parent_folders()
}
terraform {
  source = "${get_parent_terragrunt_dir()}/../_modules/data_dog/integration"
}

locals {
  global_environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  global_secret_vars      = yamldecode(sops_decrypt_file(find_in_parent_folders("global_secret.${local.global_environment_vars.locals.environment}.yaml")))
  cloudtrail_bucket_name  = "3542345-dev-cloudtrail-logging-ap-southeast-2"
}

inputs = {
  datadog_app_key                = local.global_secret_vars.DATADOG_PROVIDER_KEY
  datadog_api_key                = local.global_secret_vars.DATADOG_API_KEY
  env                            = local.global_environment_vars.locals.environment
  namespace                      = "monitoring"
  enable_datadog_aws_integration = true
  integration_role_name          = "datadog-integration-role"
  account_specific_namespace_rules = {
    api_gateway            = true
    application_elb        = false
    apprunner              = false
    appstream              = false
    appsync                = false
    athena                 = false
    auto_scaling           = false
    billing                = false
    budgeting              = false
    certificatemanager     = false
    cloudfront             = false
    cloudhsm               = false
    cloudsearch            = false
    cloudwatch_events      = true
    cloudwatch_logs        = true
    codebuild              = true
    cognito                = true
    collect_custom_metrics = true
    connect                = false
    crawl_alarms           = false
    directconnect          = false
    dms                    = false
    documentdb             = false
    dynamodb               = false
    ebs                    = false
    ec2                    = true
    ec2api                 = false
    ec2spot                = false
    ecs                    = false
    efs                    = true
    elasticache            = true
    elasticbeanstalk       = false
    elasticinference       = false
    elastictranscoder      = false
    elb                    = true
    emr                    = false
    es                     = false
    firehose               = false
    fsx                    = false
    gamelift               = false
    glue                   = false
    inspector              = false
    iot                    = false
    kinesis                = false
    kinesis_analytics      = false
    kms                    = false
    lambda                 = true
    lex                    = false
    mediaconnect           = false
    mediaconvert           = false
    mediapackage           = false
    mediatailor            = false
    ml                     = false
    mq                     = false
    msk                    = false
    nat_gateway            = false
    neptune                = false
    network_elb            = false
    networkfirewall        = false
    opsworks               = false
    polly                  = false
    rds                    = false
    redshift               = false
    rekognition            = false
    route53                = false
    route53resolver        = false
    s3                     = false
    s3storagelens          = false
    sagemaker              = false
    ses                    = true
    shield                 = false
    sns                    = true
    sqs                    = true
    step_functions         = true
    storage_gateway        = false
    swf                    = false
    transitgateway         = false
    translate              = false
    trusted_advisor        = false
    usage                  = false
    vpn                    = false
    waf                    = false
    wafv2                  = false
    workspaces             = false
    xray                   = true
  }
  excluded_regions = [
    "us-east-2",
    "us-west-1",
    "us-west-2",
    "af-south-1",
    "ap-east-1",
    "ap-south-1",
    "ap-northeast-3",
    "ap-northeast-2",
    "ap-southeast-1",
    "ap-northeast-1",
    "ca-central-1",
    "eu-central-1",
    "eu-west-1",
    "eu-west-2",
    "eu-south-1",
    "eu-west-3",
    "eu-north-1",
    "me-south-1",
    "sa-east-1",
    "us-gov-east-1",
    "us-gov-west-1"
  ]
  cloudtrail_bucket_name = local.cloudtrail_bucket_name
}
