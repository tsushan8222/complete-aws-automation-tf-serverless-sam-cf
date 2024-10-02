locals {
  default_tags = {
    env       = var.env
    namespace = var.namespace
    terraform = "true"
  }

}
