terraform {
  backend "s3" {
    bucket = "bucket-name"
    key = "key-name"
    region = "ap-south-1"
    dynamodb_table = "table-name"
    encrypt = true
  }
}