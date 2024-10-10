module "vpn" {
  source      = "../../moduels/02.sg"
  component   = "vpn"
  env         = var.env
  common_tags = var.common_tags
  vpc_id      = data.aws_ssm_parameter.vpc_id.value
  project     = var.project
}

# Security Group Rule for SSH Access
resource "aws_security_group_rule" "vpn_ssh" {
  description       = "vpn_ssh"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]  # Restrict to a specific IP
  security_group_id = module.vpn.sg_id
}

# Security Group Rule for HTTPS Access
resource "aws_security_group_rule" "vpn_https" {
  description       = "vpn_https"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]  # Open for all, consider restricting if necessary
  security_group_id = module.vpn.sg_id
}

# Security Group Rule for HTTP Access
resource "aws_security_group_rule" "vpn_http" {
  description       = "vpn_http"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]  # Open for all, consider restricting if necessary
  security_group_id = module.vpn.sg_id
}

# Security Group Rule for Admin and Client Web UIs on Access Server
resource "aws_security_group_rule" "Admin_Client" {
  description       = "Admin and Client Web UIs on Access Server"
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]  # Open for all, consider restricting if necessary
  security_group_id = module.vpn.sg_id
}

# Security Group Rule for OpenVPN Connections
resource "aws_security_group_rule" "OpenVPN_connections" {
  description       = "OpenVPN connections"
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "udp"  # Changed to UDP for OpenVPN
  cidr_blocks       = ["0.0.0.0/0"]  # Open for all, consider restricting if necessary
  security_group_id = module.vpn.sg_id
}
