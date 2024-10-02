locals {
  s3_tags = {
    Name = var.bucket_name
    Env  = var.env
  }
}

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  acl    = "private"
  tags   = merge(local.s3_tags, var.tags)
}
