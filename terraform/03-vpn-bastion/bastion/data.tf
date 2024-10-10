data "aws_ami" "ami_info" {
  most_recent = true
  owners = ["973714476881"]
  filter {
    name = "name"
    values = ["RHEL-9-DevOps-Practice"]
  }
}



data "aws_ssm_parameter" "bastion_sg_id" {
  name  = "/${var.project}/${var.env}/bastion_sg_id"
}

data "aws_ssm_parameter" "public_subnet_id" {
  name = "/${var.project}/${var.env}/public_subnet_id"
}

data "aws_ssm_parameter" "token" {
  name = "api_token"
}

data "cloudflare_zone" "zone" {
  name = "chowdary.cloud"
}

data "aws_route53_zone" "selected" {
  name         = "chowdary.cloud"
  private_zone = false
}
