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


# These are the INPUT PARAMETERS for our module
 variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "my-ec2-instance"  # Default value if not specified
}
variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
  default     = data.aws_ami.ubuntu.id  # Default to the latest Ubuntu AMI if not specified
}
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"  # Default value if not specified
}
variable "key_name" {
  description = "Name of the SSH keypair to use for the instance"
  type        = string
}
variable "vpc_id" {
  description = "VPC ID for the security group. If not specified, uses the default VPC"
  type        = string
  default     = null  # Will use default VPC if not specified
}

variable "subnet_id" {
  description = "Subnet ID for the EC2 instance. If not specified, uses the default subnet"
  type        = string
  default     = null  # Will use default subnet if not specified
}
variable "volume_size" {
  description = "Size of the root EBS volume in GB"
  type        = number
  default     = 8  # Default value if not specified
}
variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}
variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH to the instance"
  type        = string
  default     = "0.0.0.0/0"
}