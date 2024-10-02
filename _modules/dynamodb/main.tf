module "dynamodb_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"
  version = "3.1.2"

  name     = var.dynamodb_name
  # hash_key = "id"

  # attributes = [
  #   {
  #     name = "id"
  #     type = "N"
  #   }
  # ]

  tags = var.tags
}