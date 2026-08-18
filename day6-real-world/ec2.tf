data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}
 
resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_1.id  # In public subnet
  vpc_security_group_ids = [aws_security_group.web_sg.id]
 
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo '<h1>Terraform 3-Tier App on VPC!</h1>' > /var/www/html/index.html
  EOF
 
  tags = {
    Name = "web-server"
    Tier = "Web"
    }
}