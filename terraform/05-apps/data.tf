data "aws_ssm_parameter" "token" {
  name = "api_token"
}

data "cloudflare_zone" "zone" {
  name = "chowdary.cloud"
}




data "aws_ami" "ami_info" {
  most_recent = true
  owners = ["973714476881"]
  filter {
    name = "name"
    values = ["RHEL-9-DevOps-Practice"]
  }
}


data"aws_ssm_parameter" "frontend_sg_id"{
  name = "/${var.project}/${var.env}/frontend_sg_id"
}


data "aws_ssm_parameter" "backend_sg_id" {
  name  = "/${var.project}/${var.env}/backend_sg_id"
}

data "aws_ssm_parameter" "ansible_sg_id" {
  name  = "/${var.project}/${var.env}/ansible_sg_id"
}

data "aws_ssm_parameter" "public_subnet_id" {
  name = "/${var.project}/${var.env}/public_subnet_id"
}


data "aws_ssm_parameter" "private_subnet_id" {
  name = "/${var.project}/${var.env}/private_subnet_id"
}