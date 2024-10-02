resource "aws_s3_bucket_object" "this" {
  count  = length(var.keys_folder)
  bucket       = var.bucket_name
  acl          = "private"
  key          = "${var.keys_folder[count.index]}/"
  content_type = "application/x-directory"
}