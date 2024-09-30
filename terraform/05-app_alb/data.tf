data "aws_ssm_parameter" "app_alb_sg_id" {
  name = "/${var.common_tags.Project}/${var.common_tags.env}/app_alb_sg_id"
}

data "aws_ssm_parameter" "private_subnet_id" {
  name = "/${var.common_tags.Project}/${var.common_tags.env}/private_subnet_id"
}