
# #added as part of Jenkins CICD
# resource "aws_security_group_rule" "backend_default_vpc" {
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   cidr_blocks = ["172.31.0.0/16"]
#   security_group_id = module.backend.sg_id
# }
#
# #added as part of Jenkins CICD
# resource "aws_security_group_rule" "frontend_default_vpc" {
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   cidr_blocks = ["172.31.0.0/16"]
#   security_group_id = module.frontend.sg_id
# }

## db
resource "aws_security_group_rule" "db_allow_all" {
  description       = "Allow inbound MySQL traffic to the database from internal network"
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = ["172.31.0.0/16"]  # Specify internal network range
  security_group_id = module.database.sg_id  # Reference to the database security group ID
}

## backend
resource "aws_security_group_rule" "backend_ssh_allow_all" {
  description       = "Allow inbound SSH traffic to backend servers from internal network"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["172.31.0.0/16"]  # Specify internal network range
  security_group_id = module.backend.sg_id  # Reference to the backend security group ID
}

resource "aws_security_group_rule" "backend_http_allow_all" {
  description       = "Allow inbound HTTP traffic to backend servers from internal network"
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["172.31.0.0/16"]  # Specify internal network range
  security_group_id = module.backend.sg_id  # Reference to the backend security group ID
}

## frontend
resource "aws_security_group_rule" "frontend_ssh_allow_all" {
  description       = "Allow inbound SSH traffic to frontend servers from internal network"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["172.31.0.0/16"]  # Specify internal network range
  security_group_id = module.frontend.sg_id  # Reference to the frontend security group ID
}

resource "aws_security_group_rule" "frontend_http_allow_all" {
  description       = "Allow inbound HTTP traffic to frontend servers from internal network"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["172.31.0.0/16"]  # Specify internal network range
  security_group_id = module.frontend.sg_id  # Reference to the frontend security group ID
}


