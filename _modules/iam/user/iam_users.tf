resource "aws_iam_user" "user" {
  name          = var.username
  path          = "/"
  force_destroy = true
}

resource "aws_iam_user_group_membership" "group" {
  count  = var.iam_groups == [] ? 0 : length(var.iam_groups)
  user   = aws_iam_user.user.name
  groups = var.iam_groups
}

resource "aws_iam_user_login_profile" "this" {
  user                    = aws_iam_user.user.name
  password_reset_required = true
  pgp_key                 = "keybase:${var.keybase_pgp_key}"
}

locals {
  python = (substr(pathexpand("~"), 0, 1) == "/") ? "python3" : "python.exe"
}

resource "null_resource" "this" {
  provisioner "local-exec" {
    command     = "${local.python} ${path.module}/scripts/run.py --useremail ${aws_iam_user.user.name} ${aws_iam_user_login_profile.this.encrypted_password != "" ? "--passwd ${aws_iam_user_login_profile.this.encrypted_password}" : ""} --region ${var.region} --sender ${var.sender_email} --group ${jsonencode(var.iam_groups)} --bcc_email_address ${var.bcc}"
    interpreter = ["/bin/bash", "-c"]
    on_failure  = fail
  }
}
