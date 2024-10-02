data "aws_availability_zones" "this" {
  state = "available"
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.selected.id

  tags = {
    Name = "Private.*.${var.env}"
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = var.vpc_id

  tags = {
    Name = "Public.*.${var.env}"
  }
}

resource "random_id" "redis_pg" {
  keepers = {
    family = var.family
  }

  byte_length = 2
}
locals {
  vpc_subnet_ids = length(var.security_group_ids) != 0 ? var.security_group_ids : data.aws_subnet_ids.private.ids
  vpc_cidr       = length(var.ingress_cidr_blocks) != 0 ? var.ingress_cidr_blocks : [data.aws_vpc.selected.cidr_block]
}
