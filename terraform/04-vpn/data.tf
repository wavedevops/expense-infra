data "aws_ami" "ami_info" {
  most_recent = true
  owners = ["679593333241"]
  filter {
    name = "name"
    values = ["OpenVPN Access Server Community Image-fe8020db-*"]
  }
}


data "aws_ssm_parameter" "vpn_sg_id" {
  name = "/${var.project}/${var.env}/vpn_sg_id"
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