resource "aws_vpc" "example-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "example-subnet-a" {
  vpc_id     = aws_vpc.example-vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "example-subnet-c" {
  vpc_id     = aws_vpc.example-vpc.id
  cidr_block = "10.0.2.0/24"
}

resource "aws_internet_gateway" "example-vpc-ig" {
  vpc_id = aws_vpc.example-vpc.id
  tags   = {
    Name = var.app_name
  }
}
