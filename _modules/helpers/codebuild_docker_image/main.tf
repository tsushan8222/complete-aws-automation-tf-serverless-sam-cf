
locals {
  default_ecr_tags = {
    Environment = var.env
    Application = var.docker_image_name
  }
}
resource "aws_ecr_repository" "this" {
  name                 = var.docker_image_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = local.default_ecr_tags
}

resource "null_resource" "docker" {

  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command    = "/bin/bash ${data.template_file.docker.rendered}"
    on_failure = fail
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_ecr_repository.this]
}

data "aws_caller_identity" "current" {}

data "template_file" "docker" {
  template = file("${path.module}/docker_push.sh.tpl")
  vars = {
    profile        = var.env
    region         = var.aws_region
    image_name     = var.docker_image_name
    repository_url = aws_ecr_repository.this.repository_url
    account_no     = data.aws_caller_identity.current.account_id
  }
}

