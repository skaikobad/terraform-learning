# main.tf - Your very first Terraform configuration!
 
# PROVIDER BLOCK: Tells Terraform we are using AWS
# Think of this as telling Terraform 'we're working with AWS'

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
 
# Configure the AWS provider
# This tells Terraform which region to use

provider "aws" {
  region = "us-west-2"
}
 
# RESOURCE BLOCK: Creates an S3 bucket
# Syntax: resource "PROVIDER_TYPE" "YOUR_LOCAL_NAME" { ... }

resource "aws_s3_bucket" "my_first_bucket" {
  bucket = "my-terraform-learning-bucket-12345"  # Must be globally unique!
 
  tags = {
    Name        = "My First Terraform Bucket"
    Environment = "Learning"
    CreatedBy   = "Terraform"
  }
}