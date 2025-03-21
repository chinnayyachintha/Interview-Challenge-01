# Get AWS account details
data "aws_caller_identity" "current" {}


# Fetch available availability zones
data "aws_availability_zones" "available" {}