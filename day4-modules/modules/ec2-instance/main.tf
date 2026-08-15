# The actual resources this module creates
# Notice: we use var.variable_name to access module inputs

# RESOURCE 1: Security Group - controls network traffic
resource "aws_security_group" "instance_sg" {
  name        = "${var.instance_name}-${var.environment}-sg"
  description = "Security group for ${var.instance_name}"
  vpc_id      = var.vpc_id != null ? var.vpc_id : data.aws_vpc.default.id   # Use the provided VPC ID if set, otherwise use the default VPC
 
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
    }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

 
  egress {
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
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id != null ? var.subnet_id : data.aws_subnets.default.ids[0]  # Use the provided subnet ID if set, otherwise use the first default subnet
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