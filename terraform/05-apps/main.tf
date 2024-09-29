module "frontend" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name          = "${var.env}-${var.project}-frontend"
  ami           = data.aws_ami.ami_info.id
  instance_type = "t3.micro"
  subnet_id = element(split(",", data.aws_ssm_parameter.public_subnet_id.value), 0)
  vpc_security_group_ids = [data.aws_ssm_parameter.frontend_sg_id.value]

  tags = merge(
    var.common_tags,
    {
      Name = "${var.env}-${var.project}-frontend"
    }
  )
}

module "backend" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name          = "${var.env}-${var.project}-backend"
  ami           = data.aws_ami.ami_info.id
  instance_type = "t3.micro"
  subnet_id = element(split(",", data.aws_ssm_parameter.public_subnet_id.value), 0)
  vpc_security_group_ids = [data.aws_ssm_parameter.backend_sg_id.value]

  tags = merge(
    var.common_tags,
    {
      Name = "${var.env}-${var.project}-backend"
    }
  )
}


module "ansible" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name          = "${var.env}-${var.project}-ansible"
  ami           = data.aws_ami.ami_info.id
  instance_type = "t3.micro"
  subnet_id = element(split(",", data.aws_ssm_parameter.public_subnet_id.value), 0)
  vpc_security_group_ids = [data.aws_ssm_parameter.ansible_sg_id.value]
  user_data = file("expense.sh")

  tags = merge(
    var.common_tags,
    {
      Name = "${var.env}-${var.project}-ansible"
    }
  )
  depends_on = [ module.backend,module.frontend ]
}
