# ---------------------------
# VPC
# ---------------------------
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "my_vpc"
  }
}

# ---------------------------
# Public Subnet
# ---------------------------
resource "aws_subnet" "public_subnet" {
  vpc_id                   = aws_vpc.main.id
  cidr_block               = "10.0.1.0/24"
  availability_zone        = "ap-south-1a"
  map_public_ip_on_launch  = true

  tags = {
    Name = "public_subnet"
  }
}

# ---------------------------
# Private Subnet
# ---------------------------
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "private_subnet"
  }
}

# ---------------------------
# Internet Gateway
# ---------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "my_igw"
  }
}

# ---------------------------
# Public Route Table
# ---------------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_rt"
  }
}

# Associate Public Subnet with Public Route Table
resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# ---------------------------
# Private Route Table
# ---------------------------
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private_rt"
  }
}

# Associate Private Subnet with Private Route Table
resource "aws_route_table_association" "private_rt_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}
# ---------------------------