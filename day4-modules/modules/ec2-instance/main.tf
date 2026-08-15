# DATA SOURCE: Fetch the latest Ubuntu AMI automatically
# Data sources READ existing AWS resources - they don't create anything
# This is better than hardcoding an AMI ID (which changes per region)

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical's AWS account ID for Ubuntu
 
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-resolute-26.04-amd64-server-*"]
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

#Finds the AWS account's default VPC
data "aws_vpc" "default" {
  default = true
}
#Finds subnets in the default VPC, by filtering on vpc-id.
#It returns a list of subnet IDs, accessible as data.aws_subnets.default.ids. 
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# The actual resources this module creates
# Notice: we use var.variable_name to access module inputs

# RESOURCE 1: Security Group - controls network traffic
resource "aws_security_group" "instance_sg" {
  name        = "${var.instance_name}-${var.environment}-sg"
  description = "Security group for ${var.instance_name}"
  vpc_id      = var.vpc_id != null ? var.vpc_id : data.aws_vpc.default.id   # Use the provided VPC ID if set, otherwise use the default VPC
 
  ingress {
    description = "SSH access from allowed CIDR"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
    }
  ingress {
    description = "HTTP access from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
    description = "HTTPS access from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

tags = {
    Name        = "${var.instance_name}-${var.environment}-sg"
    Environment = var.environment
  }
}

# RESOURCE 2: EC2 Instance
resource "aws_instance" "ec2_instance" {
  ami                    = var.ami_id != null ? var.ami_id : data.aws_ami.ubuntu.id  # Use the provided AMI ID if set, otherwise use the latest Ubuntu AMI
  instance_type          = var.instance_type
  key_name               = var.key_name
  #subnet_id              = var.subnet_id != null ? var.subnet_id : data.aws_subnets.default.ids[0]  # Use the provided subnet ID if set, otherwise use the first default subnet
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  root_block_device {
    volume_size = var.volume_size
  }
 
  tags = {
    Name        = "${var.instance_name}-${var.environment}"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}