resource "aws_security_group" "web_alb_sg" {
  name        = "${var.env}-web-alb-sg"
  description = "SG for Web ALB Instances"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value

  ingress {
    description = "Allow HTTP traffic from the public"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS traffic from the public"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for Frontend Instances
resource "aws_security_group" "frontend_sg" {
  name        = "${var.env}-frontend-sg"
  description = "SG for Frontend Instances"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value

  ingress {
    description = "Allow HTTP traffic from Web ALB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    source_security_group_id = aws_security_group.web_alb_sg.id
  }

  ingress {
    description = "Allow SSH traffic from Bastion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    source_security_group_id = aws_security_group.bastion_sg.id
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "backend_alb_sg" {
  name        = "${var.env}-app-alb-sg"
  description = "SG for APP ALB Instances"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value

  ingress {
    description = "Allow HTTP traffic from VPN"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    source_security_group_id = aws_security_group.vpn_sg.id
  }

  ingress {
    description = "Allow HTTP traffic from Bastion"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    source_security_group_id = aws_security_group.bastion_sg.id
  }

  ingress {
    description = "Allow HTTP traffic from Frontend"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    source_security_group_id = aws_security_group.frontend_sg.id
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "backend_sg" {
  name        = "${var.env}-backend-sg"
  description = "SG for Backend Instances"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value

  ingress {
    description = "Allow HTTP traffic from App ALB"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    source_security_group_id = aws_security_group.backend_alb_sg.id
  }

  ingress {
    description = "Allow SSH traffic from Bastion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    source_security_group_id = aws_security_group.bastion_sg.id
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Security Group for Bastion Instances
resource "aws_security_group" "bastion_sg" {
  name        = "${var.env}-bastion-sg"
  description = "SG for Bastion Instances"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value

  ingress {
    description = "Allow SSH traffic from the public"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for VPN Instances
resource "aws_security_group" "vpn_sg" {
  name        = "${var.env}-vpn-sg"
  description = "SG for VPN Instances"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value

  ingress {
    description = "Allow SSH traffic from Backend"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    source_security_group_id = aws_security_group.backend_sg.id
  }

  ingress {
    description = "Allow HTTP traffic from Backend"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    source_security_group_id = aws_security_group.backend_sg.id
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
