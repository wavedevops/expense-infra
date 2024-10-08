
resource "aws_security_group_rule" "backend_vpn_ssh" {
  description       = "vpn-ssh-sg"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = data.aws_security_group.allow_all.id # source is where you are getting traffic from
  security_group_id = module.backend.sg_id
}

resource "aws_security_group_rule" "backend_vpn_http" {
  description       = "vpn-http-sg"
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = data.aws_security_group.allow_all.id # source is where you are getting traffic from
  security_group_id = module.backend.sg_id
}


