module "bastion" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name          = "${var.env}-${var.component}"
  ami           = data.aws_ami.ami_info.id
  instance_type = var.instance_type
  subnet_id = element(split(",", data.aws_ssm_parameter.public_subnet_id.value), 0)
  vpc_security_group_ids = [data.aws_ssm_parameter.bastion_sg_id.value]

  tags = merge(
    var.common_tags,
    {
      Name = "${var.env}-${var.component}"
    }
  )
}


