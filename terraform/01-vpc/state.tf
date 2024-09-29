terraform {
  backend "s3" {
    bucket = "chowdary-hari"
    key    = "test/vpc/terraform.state"
    region = "us-east-1"
  }
}
