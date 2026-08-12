# outputs.tf
# Outputs display useful information after terraform apply
 
output "instance_public_ip" {
  description = "The public IP address of the web server"
  value       = aws_instance.web_server.public_ip
}
 
output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.web_server.id
}
 
output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.web_sg.id
}
 
output "website_url" {
  description = "URL to access the web server"
  value       = "http://${aws_instance.web_server.public_ip}"
}
output "web_server_name" {
  description = "The name of the web server"
  value       = aws_instance.web_server.public_dns
}