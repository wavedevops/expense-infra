# AWS Provider Configuration
provider "aws" {
  region = "us-east-1"
}

# Cloudflare Provider Configuration

# Terraform Backend Configuration (S3 for State Storage)
terraform {
  backend "s3" {
    bucket = "chowdary-hari"                 # S3 bucket name for storing Terraform state
    key    = "test/vpn/terraform.state"      # State file path inside the S3 bucket
    region = "us-east-1"                     # AWS region where the S3 bucket is located
  }
}