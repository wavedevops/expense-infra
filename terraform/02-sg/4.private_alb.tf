module "app_alb" {
  source      = "../../moduels/02.sg"
  component   = "private-alb"
  env         = var.env
  common_tags = var.common_tags
  vpc_id      = data.aws_ssm_parameter.vpc_id.value
  project     = var.project
}
resource "aws_security_group_rule" "app_alb_vpn" {
  description       = "vpn-sg"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id # source is where you are getting traffic from
  security_group_id = module.app_alb.sg_id
}

resource "aws_security_group_rule" "app_alb_bastion" {
  description       = "bastion-sg"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id # source is where you are getting traffic from
  security_group_id = module.app_alb.sg_id
}

resource "aws_security_group_rule" "app_alb_frontend" {
  description       = "frontend-sg"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.frontend.sg_id # source is where you are getting traffic from
  security_group_id = module.app_alb.sg_id
}