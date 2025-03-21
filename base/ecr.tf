# Create multiple ECR repositories using a loop
resource "aws_ecr_repository" "repositories" {
  for_each     = toset(["quotes", "newsfeed", "front_end"])
  name         = "${var.prefix}-${each.key}"
  force_delete = true
}

# Local variable for base ECR URL
locals {
  ecr_url = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.prefix}"
}

# Store ECR URL in AWS SSM Parameter Store
resource "aws_ssm_parameter" "ecr" {
  name  = "/${var.prefix}/ecr/base_url"
  value = local.ecr_url
  type  = "String"
}

# Store ECR URL in a local file (optional)
resource "local_file" "ecr" {
  filename = "${path.module}/../ecr-url.txt"
  content  = local.ecr_url
}


