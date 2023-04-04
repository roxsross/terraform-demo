resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "http-crud-tutorial-items-tf"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Project     = "demo-terraform"
    Owner       = "DevOps Team"
    Environment = "dev"
  }
}