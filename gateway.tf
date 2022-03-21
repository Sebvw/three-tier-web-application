resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Test internet gateway"
  }
}

# NAT Gateway in AZ A
resource "aws_nat_gateway" "nat-az-a" {
  subnet_id     = aws_subnet.public-1.id
  allocation_id = aws_eip.nat_a.id

  tags = {
    Name = "Test NAT gateway AZ A"
  }

  depends_on = [
    aws_subnet.public-1
  ]
}

resource "aws_eip" "nat_a" {
  vpc = true

  tags = {
    Name = "eip-nat-a"
  }

}

# NAT Gateway in AZ B
resource "aws_nat_gateway" "nat-az-b" {
  subnet_id     = aws_subnet.public-2.id
  allocation_id = aws_eip.nat_b.id

  tags = {
    Name = "Test NAT gateway AZ B"
  }

  depends_on = [
    aws_subnet.public-2
  ]
}

resource "aws_eip" "nat_b" {
  vpc = true

  tags = {
    Name = "eip-nat-b"
  }

}
