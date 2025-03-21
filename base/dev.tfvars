# CIDR block for the entire VPC
vpc_cidr = "10.0.0.0/16"

# CIDR block for public subnet in Availability Zone A
public_subnet_a_cidr = "10.0.10.0/24"

# CIDR block for public subnet in Availability Zone B
public_subnet_b_cidr = "10.0.11.0/24"

# CIDR block for private subnet in Availability Zone A
private_subnet_a_cidr = "10.0.20.0/24"

# CIDR block for private subnet in Availability Zone B
private_subnet_b_cidr = "10.0.21.0/24"

# AWS region where resources will be deployed
aws_region = "ca-central-1"

# Prefix for resource naming (helps distinguish between environments)
prefix = "dev"
