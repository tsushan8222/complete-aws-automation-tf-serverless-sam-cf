include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../_modules/iam/role"
}

locals {
    accounts              = read_terragrunt_config("${get_parent_terragrunt_dir()}/central/account.hcl")
    policies = {
    "Version": "2012-10-17",
    "Statement": [{
        "Effect": "Allow",
        "Action": "ec2:*",
        "Resource": "*",
        "Condition": {
            "ForAllValues:StringLike": {
                "ec2:InstanceType": [
                    "t2.small",
                    "t2.medium",
                    "t3.small",
                    "t3.medium"
                ]
            }
        }
      },
      {
            "Effect": "Allow",
            "Action": [
              "route53resolver:CreateResolverEndpoint",
              "route53resolver:UpdateResolverEndpoint",
              "route53:CreateTrafficPolicy",
              "route53:UpdateTrafficPolicyInstance",
              "route53:ChangeResourceRecordSets"
            ]
            "Resource": "*"
        },
      
      
      ]
    }
}

inputs = {   
    central_acc_role_arn = "arn:aws:iam::${local.accounts.locals.aws_account_id}:root"
    assume_role_name = "developers"
    managed_policies = ["AmazonS3FullAccess","AmazonAPIGatewayAdministrator", "AWSLambda_FullAccess", "CloudWatchLogsFullAccess", "AmazonSSMFullAccess", "SecretsManagerReadWrite", "AmazonSNSReadOnlyAccess", "AmazonSQSFullAccess", "CloudFrontFullAccess", "AWSCloudFormationFullAccess"]
    inline_policy = local.policies == {} ? "" : jsonencode(local.policies)
}