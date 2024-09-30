module "web_alb" {
  source      = "../../moduels/02.sg"
  component   = "public-alb"
  env         = var.env
  common_tags = var.common_tags
  vpc_id      = data.aws_ssm_parameter.vpc_id.value
  project     = var.project
}

resource "aws_security_group_rule" "web_alb_public" {
  description       = "public port 80"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.web_alb.sg_id
}

resource "aws_security_group_rule" "web_alb_public_https" {
  description       = "public port 443"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.web_alb.sg_id
}
