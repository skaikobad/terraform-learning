# Create the VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"  # 65,536 IP addresses
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = { Name = "main-vpc" }
}
 
# Internet Gateway - connects VPC to internet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "main-igw" }
}
 
# --- PUBLIC SUBNETS (two AZs for high availability) ---
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"  # 256 IPs
  availability_zone       = "us-west-1a"
  map_public_ip_on_launch = true            # Auto-assign public IPs
  tags = { Name = "public-subnet-1a" }
}
 
resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-west-1b"
  map_public_ip_on_launch = true
  tags = { Name = "public-subnet-1b" }
}
 
# --- PRIVATE SUBNETS --
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "us-west-1a"
  tags = { Name = "private-subnet-1a" }
}
 
resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "us-west-1b"
  tags = { Name = "private-subnet-1b" }
}
 
# Route table for public subnets
# Send any traffic that doesn't match a more specific route out to the internet through this Internet Gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"  #  This is the destination CIDR block, it's called the default route
    gateway_id = aws_internet_gateway.igw.id  # Route to internet
  }
  tags = { Name = "public-rt" }
}
 
# Associate public route table with public subnets
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}
 
resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}