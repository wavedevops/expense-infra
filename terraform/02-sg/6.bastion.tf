module "bastion" {
  source      = "../../moduels/02.sg"
  component   = "bastion"
  env         = var.env
  common_tags = var.common_tags
  vpc_id      = data.aws_ssm_parameter.vpc_id.value
  project     = var.project

}

resource "aws_security_group_rule" "bastion_public" {
  description       = "bastion-public"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.bastion.sg_id
}
