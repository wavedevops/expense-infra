## db
resource "aws_security_group_rule" "vpn_ssh_default_sg" {
  description       = "Allow SSH access from allow all security group"
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = data.aws_security_group.allow_all.id  # Use default security group ID
  security_group_id = module.database.sg_id  # Reference to your security group ID
}

## backend
resource "aws_security_group_rule" "vpn_ssh_default_sg" {
  description       = "Allow SSH access from allow all security group"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = data.aws_security_group.allow_all.id  # Use default security group ID
  security_group_id = module.backend.sg_id  # Reference to your security group ID
}

resource "aws_security_group_rule" "vpn_ssh_default_sg" {
  description       = "Allow SSH access from allow all security group"
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = data.aws_security_group.allow_all.id  # Use default security group ID
  security_group_id = module.backend.sg_id  # Reference to your security group ID
}

## backend
resource "aws_security_group_rule" "vpn_ssh_default_sg" {
  description       = "Allow SSH access from allow all security group"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = data.aws_security_group.allow_all.id  # Use default security group ID
  security_group_id = module.frontend.sg_id  # Reference to your security group ID
}

resource "aws_security_group_rule" "vpn_ssh_default_sg" {
  description       = "Allow SSH access from allow all security group"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = data.aws_security_group.allow_all.id  # Use default security group ID
  security_group_id = module.frontend.sg_id  # Reference to your security group ID
}

