data "aws_ssm_parameter" "frontend_sg_id" {
  name = "/${var.project}/${var.env}/frontend_sg_id"
}

data "aws_ssm_parameter" "app_alb_sg_id" {
  name = "/${var.project}/${var.env}/app_alb_sg_id"
}

data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project}/${var.env}/vpc_id"
}

data "aws_ssm_parameter" "private_subnet_id" {
  name = "/${var.project}/${var.env}/private_subnet_id"
}

data "aws_ssm_parameter" "public_subnet_id" {
  name = "/${var.project}/${var.env}/public_subnet_id"
}


data "aws_ami" "ami_info" {
  most_recent = true
  owners = ["973714476881"]
  filter {
    name = "name"
    values = ["RHEL-9-DevOps-Practice"]
  }
}

data "aws_route53_zone" "zone" {
  name         = "chowdary.cloud"
  private_zone = false
}


