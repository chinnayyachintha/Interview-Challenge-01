resource "aws_s3_bucket" "news" {
  bucket        = "${var.prefix}-terraform-infra-static-pages"
  force_destroy = false  # Changed to false for safety

  tags = {
    Name        = "News Static Site"
    Environment = "Production"
    Purpose     = "Static Website Hosting"
  }
}

resource "aws_s3_bucket_website_configuration" "news" {
  bucket = aws_s3_bucket.news.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "news" {
  bucket = aws_s3_bucket.news.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"  # Enhanced encryption
    }
  }
}

resource "aws_s3_bucket_versioning" "news" {
  bucket = aws_s3_bucket.news.id
  versioning_configuration {
    status = "Enabled"  # Added for better content management
  }
}

resource "aws_s3_bucket_public_access_block" "news" {
  bucket                  = aws_s3_bucket.news.id
  block_public_acls       = true   # More secure default
  block_public_policy     = false  # Allows policy-based public access
  ignore_public_acls      = true   # Ignores legacy ACLs
  restrict_public_buckets = true   # Restricts to policy-defined access
}

resource "aws_s3_bucket_ownership_controls" "news" {
  bucket = aws_s3_bucket.news.id
  
  rule {
    object_ownership = "BucketOwnerEnforced"  # Modern preference over BucketOwnerPreferred
  }
}

# Removed aws_s3_bucket_acl - Legacy, replaced by bucket policy

resource "aws_s3_bucket_policy" "news" { 
  bucket = aws_s3_bucket.news.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "newsBucketPolicy"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.news.arn}/*"
        Condition = {
          Bool = {
            "aws:SecureTransport" = "true"  # Enforce HTTPS
          }
        }
      }
      # Removed ListBucket permission - unnecessary for static website
    ]
  })
}

# Added lifecycle configuration for better management
resource "aws_s3_bucket_lifecycle_configuration" "news" {
  bucket = aws_s3_bucket.news.id

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

# Added CORS for web compatibility
resource "aws_s3_bucket_cors_configuration" "news" {
  bucket = aws_s3_bucket.news.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]  # Restrict this in production if possible
    max_age_seconds = 3000
  }
}