# AWS Provider Configuration
provider "aws" {
  region = "us-east-1"
}

# Terraform Backend Configuration (S3 for State Storage)
terraform {
  backend "s3" {
    bucket = "chowdary-hari"
    key    = "test/rds/terraform.state"
    region = "us-east-1"
  }
}
