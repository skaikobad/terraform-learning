# These are the OUTPUT RETURN VALUES of our module
 
output "instance_id" {
  description = "ID of the created EC2 instance"
  value       = aws_instance.ec2_instance.id
}
 
output "public_ip" {
  description = "Public IP of the instance"
  value       = aws_instance.ec2_instance.public_ip
}
 
output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.instance_sg.id
}