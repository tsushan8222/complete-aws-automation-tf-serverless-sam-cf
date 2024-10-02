resource "aws_codebuild_report_group" "this" {
  name = "${var.env}-${var.application_name}"
  type = "CODE_COVERAGE"

  export_config {
    type = "S3"

    s3_destination {
      bucket              = var.logging_bucket_name
      encryption_key      = "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:alias/aws/s3"
      packaging           = "NONE"
      path                = "/report"
    }
  }
}
