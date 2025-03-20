terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.9.0"
    }
  }
}

# Setup our aws provider
provider "aws" {
  region = var.aws_region
}
