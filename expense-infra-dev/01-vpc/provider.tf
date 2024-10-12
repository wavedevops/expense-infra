terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.48.0"
    }
  }
  backend "s3" {
    bucket = "chowdary.cloud"
    key    = "expense-dev-vpc"
    region = "us-east-1"
  }
}

#provide authentication here
provider "aws" {
  region = "us-east-1"
}