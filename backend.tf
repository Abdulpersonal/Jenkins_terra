terraform {
  backend "s3" {
    bucket = "staircase-s3-terraform-state"
    key    = "statefile"
    region = "us-east-1"
    dynamodb_table = "staircase-dynamodb"
  }
}
