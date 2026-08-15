# This is where we CALL our module, like calling a function
 
# Deploy a web server in dev
module "web_server_dev" {
  source = "./modules/ec2-instance"  # Point to our module
 
  # Pass inputs to the module (like function arguments)
  instance_name = "web-server"
  environment   = "dev"
  instance_type = "t2.micro"
  key_name      = "MERN_PC_KEY"
}
 
# Deploy a web server in prod with different settings
module "web_server_prod" {
  source = "./modules/ec2-instance"
 
  instance_name = "web-server"
  environment   = "prod"
  instance_type = "t2.small"  # Bigger instance for prod
  key_name      = "MERN_PC_KEY"
  volume_size = 10
}
 
# Access module outputs
output "dev_server_ip" {
  value = module.web_server_dev.public_ip
}
 
output "prod_server_ip" {
  value = module.web_server_prod.public_ip
}