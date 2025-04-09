# DynamoDB table for state locking
resource "aws_dynamodb_table" "dynamodb-table" {
  name           = "${var.prefix}-terraform-locks-1"
  billing_mode   = "PAY_PER_REQUEST"  # Cost-effective for low-traffic locking
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  deletion_protection_enabled = true  # Protect the table from accidental deletion  

  tags = {
    Name        = "Terraform Lock Table"
    CreatedBy   = "infra/backend-support ${var.prefix}"
  }
}