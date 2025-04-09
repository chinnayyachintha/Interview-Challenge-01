terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.94.1"
    }
  }
}

# Setup our aws provider
provider "aws" {
  region = var.aws_region
}
