resource "aws_ssm_parameter" "database" {
  name  = "/${var.project}/${var.env}/database_sg_id"
  type  = "String"
  value = module.database.sg_id
}

resource "aws_ssm_parameter" "backend" {
  name  = "/${var.project}/${var.env}/backend_sg_id"
  type  = "String"
  value = module.backend.sg_id
}

resource "aws_ssm_parameter" "frontend" {
  name  = "/${var.project}/${var.env}/frontend_sg_id"
  type  = "String"
  value = module.frontend.sg_id
}


resource "aws_ssm_parameter" "bastion" {
  name  = "/${var.project}/${var.env}/bastion_sg_id"
  type  = "String"
  value = module.bastion.sg_id
}

resource "aws_ssm_parameter" "vpn" {
  name  = "/${var.project}/${var.env}/vpn_sg_id"
  type  = "String"
  value = module.vpn.sg_id
}

resource "aws_ssm_parameter" "public_alb" {
  name  = "/${var.project}/${var.env}/web_alb_sg_id"
  type  = "String"
  value = module.web_alb.sg_id
}

resource "aws_ssm_parameter" "private_alb" {
  name  = "/${var.project}/${var.env}/app_alb_sg_id"
  type  = "String"
  value = module.app_alb.sg_id
}