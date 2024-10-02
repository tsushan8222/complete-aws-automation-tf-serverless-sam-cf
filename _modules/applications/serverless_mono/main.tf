locals {
  python = (substr(pathexpand("~"), 0, 1) == "/") ? "python3" : "python.exe"
}
resource "null_resource" "this" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command    = "${local.python} ${path.module}/scripts/run.py --serverlessdir ${var.serveless_yaml_dir} --envoutput ${var.env_output_file_location} --envvars ${join(" ", var.env_variables)} ${var.before_deploy_sh_location != null ? "--beforescript ${var.before_deploy_sh_location}" : ""} ${var.after_deploy_sh_location != null ? "--afterscript ${var.after_deploy_sh_location}" : ""}"
    on_failure = fail
  }
  lifecycle {
    create_before_destroy = true
  }
}
