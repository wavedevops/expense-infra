# AWS Provider Configuration
provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "chowdary-hari"                 # S3 bucket name for storing Terraform state
    key    = "test/frontend/terraform.state"      # State file path inside the S3 bucket
    region = "us-east-1"                     # AWS region where the S3 bucket is located
  }
}
