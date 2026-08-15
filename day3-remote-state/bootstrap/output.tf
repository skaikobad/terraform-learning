# Output the bucket name so we can use it in the next part
output "state_bucket_name" {
  value = aws_s3_bucket.terraform_state.bucket
}
 
output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_locks.name
}
