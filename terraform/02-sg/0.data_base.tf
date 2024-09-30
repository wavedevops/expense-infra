module "database" {
  source      = "../../moduels/02.sg"
  component   = "database"
  env         = var.env
  common_tags = var.common_tags
  vpc_id      = data.aws_ssm_parameter.vpc_id.value
  project     = var.project
}

resource "aws_security_group_rule" "database" {
  description              = "database"
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.backend.sg_id
  security_group_id        = module.database.sg_id
}

resource "aws_security_group_rule" "db_bastion" {
  description              = "bastion-sg"
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.database.sg_id
}

resource "aws_security_group_rule" "db_vpn" {
  description              = "vpn-sg"
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.database.sg_id
}
