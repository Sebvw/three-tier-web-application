resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Test VPC"
  }
}

# Create route table for the public subnets
# Uses IG
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }

  depends_on = [
    aws_internet_gateway.igw
  ]
}

# Associate the public subnets with the public route table
resource "aws_route_table_association" "public-1" {
  subnet_id      = aws_subnet.public-1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-2" {
  subnet_id      = aws_subnet.public-2.id
  route_table_id = aws_route_table.public.id
}

#---
resource "aws_route_table" "rt_aza" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-az-a.id
  }

  tags = {
    Name = "Route-table-aza"
  }

  depends_on = [
    aws_nat_gateway.nat-az-a
  ]
}

resource "aws_route_table" "rt_azb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-az-b.id
  }

  tags = {
    Name = "Route-table-azb"
  }

  depends_on = [
    aws_nat_gateway.nat-az-b
  ]
}

resource "aws_route_table_association" "web_aza" {
  subnet_id      = aws_subnet.web-1.id
  route_table_id = aws_route_table.rt_aza.id
}

resource "aws_route_table_association" "web_azb" {
  subnet_id      = aws_subnet.web-2.id
  route_table_id = aws_route_table.rt_aza.id
}
