# Define VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name      = "${var.prefix}-vpc"
    createdBy = "infra-${var.prefix}/base"
  }
}

resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.prefix}/base/vpc_id"
  value = aws_vpc.vpc.id
  type  = "String"
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name      = "${var.prefix}-igw"
    createdBy = "infra-${var.prefix}/base"
  }
}

# Public Route Table
resource "aws_route_table" "public_routes" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name      = "${var.prefix}-public-rt"
    createdBy = "infra-${var.prefix}/base"
  }
}

# Public Subnets
resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_a_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name      = "${var.prefix}-public-subnet-a"
    createdBy = "infra-${var.prefix}/base"
  }
}

resource "aws_ssm_parameter" "subnet_a" {
  name  = "/${var.prefix}/base/subnet/a/id"
  value = aws_subnet.public_subnet_a.id
  type  = "String"
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_b_cidr
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name      = "${var.prefix}-public-subnet-b"
    createdBy = "infra-${var.prefix}/base"
  }
}

resource "aws_ssm_parameter" "subnet_b" {
  name  = "/${var.prefix}/base/subnet/b/id"
  value = aws_subnet.public_subnet_b.id
  type  = "String"
}

# Associate Route Table to Public Subnets
resource "aws_route_table_association" "public_subnet_a_association" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_routes.id
}

resource "aws_route_table_association" "public_subnet_b_association" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_routes.id
}

# NAT Gateway Setup for Private Subnets
resource "aws_eip" "nat" {}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet_a.id
}

# Private Route Table
resource "aws_route_table" "private_routes" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

# Private Subnets
resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_a_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name      = "${var.prefix}-private-subnet-a"
    createdBy = "infra-${var.prefix}/base"
  }
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_b_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name      = "${var.prefix}-private-subnet-b"
    createdBy = "infra-${var.prefix}/base"
  }
}

# Associate Route Table to Private Subnets
resource "aws_route_table_association" "private_subnet_a_association" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private_routes.id
}

resource "aws_route_table_association" "private_subnet_b_association" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.private_routes.id
}
