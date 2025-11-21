provider "aws" {
  region = "ap-south-1"
}

# Default VPC use karna
data "aws_vpc" "default" {
  default = true
}

# Subnet create karna Terraform se
resource "aws_subnet" "default_subnet" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = "172.31.0.0/20"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "default-subnet"
  }
}

# SSH allow karne ke liye Security Group
resource "aws_security_group" "ssh_access" {
  name        = "allow_ssh"
  description = "Allow SSH Access"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Key pair
resource "aws_key_pair" "mykey" {
  key_name   = "mykey"
  public_key = file("E:/Devops learning/terraform_hands_on_labs/id_rsa.pub")
}


# Single EC2 Instance
resource "aws_instance" "myserver" {
  ami                    = "ami-02b8269d5e85954ef"  # Amazon Linux 2 - Mumbai
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.mykey.key_name
  subnet_id              = aws_subnet.default_subnet.id
  vpc_security_group_ids = [aws_security_group.ssh_access.id]

  tags = {
    Name = "single-ec2"
  }
}

