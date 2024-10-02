locals {
  parameter_store_values = { for v in var.env_variables : lookup(v, "name") => v.value if v.type == "PARAMETER_STORE" }
  secret_manager_values  = { for v in var.env_variables : lookup(v, "name") => v.value if v.type == "SECRETS_MANAGER" }
}


