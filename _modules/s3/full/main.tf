locals {
  s3_tags = {
    Name = var.bucket_name
    Env  = var.env
  }
}

module "s3" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.9.0"

  create_bucket = var.create_bucket

  bucket                                = var.bucket_name
  bucket_prefix                         = var.bucket_prefix
  acl                                   = var.acl
  server_side_encryption_configuration  = var.server_side_encryption_configuration
  attach_elb_log_delivery_policy        = var.attach_elb_log_delivery_policy
  attach_lb_log_delivery_policy         = var.attach_lb_log_delivery_policy
  attach_deny_insecure_transport_policy = var.attach_deny_insecure_transport_policy
  attach_policy                         = var.attach_policy
  attach_public_policy                  = var.attach_public_policy
  policy                                = var.policy
  acceleration_status                   = var.acceleration_status
  request_payer                         = var.request_payer
  website                               = var.website
  cors_rule                             = var.cors_rule
  versioning                            = var.versioning
  logging                               = var.logging
  grant                                 = var.grant
  lifecycle_rule                        = var.lifecycle_rule
  replication_configuration             = var.replication_configuration
  object_lock_configuration             = var.object_lock_configuration
  block_public_acls                     = var.block_public_acls
  block_public_policy                   = var.block_public_policy
  ignore_public_acls                    = var.ignore_public_acls
  restrict_public_buckets               = var.restrict_public_buckets
  control_object_ownership              = var.control_object_ownership
  object_ownership                      = var.object_ownership


  tags = merge(local.s3_tags, var.tags)

  force_destroy = var.force_destroy
}
