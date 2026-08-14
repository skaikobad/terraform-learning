# main-app/main.tf
 
terraform {
  required_providers {
    aws = { 
        source = "hashicorp/aws" 
        version = "~> 5.0" 
        }
  }
 
  # BACKEND CONFIGURATION - This is the remote state setup!
  # Replace YOUR-BUCKET-NAME with the output from the bootstrap step
  backend "s3" {
    bucket         = "YOUR-BUCKET-NAME-HERE"
    key            = "learning/main-app/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "terraform-state-locks"
  }
}
 
provider "aws" { 
    region = "us-west-2"
}
 
# Create a simple S3 bucket to test remote state
resource "aws_s3_bucket" "app_bucket" {
  bucket = "my-app-data-bucket-skaikobad"
 
  tags = {
    Name        = "App Data Bucket"
    ManagedBy   = "Terraform"
  }
}
