# S3 bucket for Terraform states
resource "aws_s3_bucket" "terraform_infra" {
  bucket        = "${var.prefix}-terraform-infra-1"
  force_destroy = false  # Protect state files from accidental deletion

  tags = {
    Name        = "Bucket for terraform states of ${var.prefix}"
    CreatedBy   = "infra/backend-support"
  }
}

# Enable versioning
resource "aws_s3_bucket_versioning" "terraform_infra" {
  bucket = aws_s3_bucket.terraform_infra.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_infra" {
  bucket = aws_s3_bucket.terraform_infra.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Updated lifecycle configuration resource
resource "aws_s3_bucket_lifecycle_configuration" "terraform_infra" {
  bucket = aws_s3_bucket.terraform_infra.id

  rule {
    id     = "expire-old-versions"
    status = "Enabled"

    filter {
      prefix = ""  # Applies to all objects in the bucket
    }

    noncurrent_version_expiration {
      noncurrent_days = 90  # Expire non-current versions after 90 days
    }
  }
}

