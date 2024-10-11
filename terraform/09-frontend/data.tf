data "aws_ssm_parameter" "frontend_sg_id" {
  name = "/${var.project}/${var.env}/frontend_sg_id"
}

data "aws_ssm_parameter" "web_alb_sg_id" {
  name = "/${var.project}/${var.env}/web_alb_sg_id"
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

data "aws_ssm_parameter" "web_alb_listener_arn_https" {
  name = "/${var.project}/${var.env}/web_alb_listener_arn_https"
}


data "aws_ami" "frontend_ami" {
  most_recent = true
  owners = ["self"]
  filter {
    name = "name"
    values = ["${var.project}-${var.env}-${var.component}"]
  }
}


data "aws_route53_zone" "zone" {
  name         = "chowdary.cloud"
  private_zone = false
}


