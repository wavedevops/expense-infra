terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.62.0"
    }
  }
  backend "s3" {
    bucket = "chowdary.cloud"
    key    = "expense-dev-db"
    region = "us-east-1"
  }
}

#provide authentication here
provider "aws" {
  region = "us-east-1"
}