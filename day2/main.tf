# main.tf
 
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
 
# RESOURCE 1: Security Group - controls network traffic
# A security group is like a firewall for your EC2 instance

resource "aws_security_group" "web_sg" {
  name        = "web-server-sg"
  description = "Security group for web server"
  # INGRESS = Incoming traffic (who can talk TO your server)
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # 0.0.0.0/0 means 'from anywhere'
  }
 
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # In production, use YOUR IP only!
  }
 
  # EGRESS = Outgoing traffic (what your server can access)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"        # -1 means ALL protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  tags = {
    Name = "web-server-sg"
  }
}
 
# RESOURCE 2: EC2 Instance
# Note how we REFERENCE the security group and AMI from above

resource "aws_instance" "web_server" {
  ami           = data.aws_ami.ubuntu.id  # Reference the data source
  instance_type = "t2.micro"                    # Free tier eligible!
 
  # Reference the security group we created above
  vpc_security_group_ids = [aws_security_group.web_sg.id]
 
  # user_data runs a script when the instance first starts
  user_data = <<-EOF
    #!/bin/bash
    apt update -y
    apt install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo '<h1>Hello from Terraform!</h1>' > /var/www/html/index.html
  EOF
 
 tags = {
    Name        = "terraform-web-server"
    Environment = "Learning"
  }
}