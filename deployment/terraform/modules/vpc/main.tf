# main.tf for VPC module

resource "aws_vpc" "commercial_manager_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "commercial-manager-vpc"
  }
}

resource "aws_subnet" "commercial_manager_public_subnet_a" {
  vpc_id            = aws_vpc.commercial_manager_vpc.id
  cidr_block        = var.public_subnet_cidr_a
  availability_zone = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "commercial-manager-public-subnet-a"
  }
}

resource "aws_subnet" "commercial_manager_public_subnet_b" {
  vpc_id            = aws_vpc.commercial_manager_vpc.id
  cidr_block        = var.public_subnet_cidr_b
  availability_zone = "${var.aws_region}b"
  map_public_ip_on_launch = true

  tags = {
    Name = "commercial-manager-public-subnet-b"
  }
}

resource "aws_subnet" "commercial_manager_private_subnet_a" {
  vpc_id            = aws_vpc.commercial_manager_vpc.id
  cidr_block        = var.private_subnet_cidr_a
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "commercial-manager-private-subnet-a"
  }
}

resource "aws_subnet" "commercial_manager_private_subnet_b" {
  vpc_id            = aws_vpc.commercial_manager_vpc.id
  cidr_block        = var.private_subnet_cidr_b
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "commercial-manager-private-subnet-b"
  }
}

resource "aws_internet_gateway" "commercial_manager_igw" {
  vpc_id = aws_vpc.commercial_manager_vpc.id

  tags = {
    Name = "commercial-manager-igw"
  }
}

resource "aws_route_table" "commercial_manager_public_rt_a" {
  vpc_id = aws_vpc.commercial_manager_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.commercial_manager_igw.id
  }

  tags = {
    Name = "commercial-manager-public-rt-a"
  }
}

resource "aws_route_table_association" "commercial_manager_public_rta_a" {
  subnet_id      = aws_subnet.commercial_manager_public_subnet_a.id
  route_table_id = aws_route_table.commercial_manager_public_rt_a.id
}

resource "aws_route_table" "commercial_manager_public_rt_b" {
  vpc_id = aws_vpc.commercial_manager_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.commercial_manager_igw.id
  }

  tags = {
    Name = "commercial-manager-public-rt-b"
  }
}

resource "aws_route_table_association" "commercial_manager_public_rta_b" {
  subnet_id      = aws_subnet.commercial_manager_public_subnet_b.id
  route_table_id = aws_route_table.commercial_manager_public_rt_b.id
}

resource "aws_route_table" "commercial_manager_private_rt_a" {
  vpc_id = aws_vpc.commercial_manager_vpc.id

  tags = {
    Name = "commercial-manager-private-rt-a"
  }
}

resource "aws_route_table_association" "commercial_manager_private_rta_a" {
  subnet_id      = aws_subnet.commercial_manager_private_subnet_a.id
  route_table_id = aws_route_table.commercial_manager_private_rt_a.id
}

resource "aws_route_table" "commercial_manager_private_rt_b" {
  vpc_id = aws_vpc.commercial_manager_vpc.id

  tags = {
    Name = "commercial-manager-private-rt-b"
  }
}

resource "aws_route_table_association" "commercial_manager_private_rta_b" {
  subnet_id      = aws_subnet.commercial_manager_private_subnet_b.id
  route_table_id = aws_route_table.commercial_manager_private_rt_b.id
}