# DB Subnet Group - RDS needs to know which subnets to use
resource "aws_db_subnet_group" "main" {
  name       = "main-db-subnet-group"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]
  tags       = { Name = "main-db-subnet-group" }
}
 
# RDS MySQL Instance
resource "aws_db_instance" "mysql" {
  identifier             = "app-mysql"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"  # Free tier eligible
  allocated_storage      = 20
  storage_type           = "gp3"
  db_name                = "appdb"
  username               = "admin"
  password               = "TerraformLab2024!"  # Use secrets manager in prod!
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot    = true  # For lab only - always snapshot in prod!
  publicly_accessible    = false  # In private subnet - not accessible from internet
 
  tags = { 
    Name = "app-mysql"
    Tier = "Database"
    }
}