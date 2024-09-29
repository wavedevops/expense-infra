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

resource "aws_ssm_parameter" "ansible" {
  name  = "/${var.project}/${var.env}/ansible_sg_id"
  type  = "String"
  value = module.ansible.sg_id
}

resource "aws_ssm_parameter" "bastion" {
  name  = "/${var.project}/${var.env}/bastion_sg_id"
  type  = "String"
  value = module.bastion.sg_id
}