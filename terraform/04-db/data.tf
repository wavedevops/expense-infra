data "aws_ssm_parameter" "database_sg_id" {
  name = "/${var.project}/${var.env}/database_sg_id"
}

data "aws_ssm_parameter" "db_subnet_id" {
  name  = "/${var.project}/${var.env}/db_subnet_id"
}



data "aws_route53_zone" "zone" {
  name         = "chowdary.cloud"
  private_zone = false
}
