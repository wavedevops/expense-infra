# AWS Provider Configuration
provider "aws" {
  region = "us-east-1"
}

# Cloudflare Provider Configuration
provider "cloudflare" {
  api_token = data.aws_ssm_parameter.token.value  # Fetch API token from AWS SSM Parameter Store
}

# Terraform Backend Configuration (S3 for State Storage)
terraform {
  backend "s3" {
    bucket = "chowdary-hari"
    key    = "test/rds/terraform.state"
    region = "us-east-1"
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"      # Use Cloudflare provider from official source
      version = "~> 4.0"                     # Pin version to avoid breaking changes
    }
  }
}
