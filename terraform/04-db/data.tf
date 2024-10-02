data "aws_ssm_parameter" "database_sg_id" {
  name = "/${var.project}/${var.env}/database_sg_id"
}

data "aws_ssm_parameter" "db_subnet_id" {
  name  = "/${var.project}/${var.env}/db_subnet_id"
}

data "aws_ssm_parameter" "token" {
  name = "api_token"
}

data "cloudflare_zone" "zone" {
  name = "chowdary.cloud"
}