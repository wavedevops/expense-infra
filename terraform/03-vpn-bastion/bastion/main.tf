resource "aws_instance" "bastion" {
  ami           = data.aws_ami.ami_info.id
  instance_type = var.instance_type
  subnet_id = element(split(",", data.aws_ssm_parameter.public_subnet_id.value), 0)
  vpc_security_group_ids = [data.aws_ssm_parameter.bastion_sg_id.value]
  #user_data = file("userdata.sh")
  tags = merge(
    var.common_tags,
    {
      Name = "${var.project}-${var.env}-${var.component}"
    }
  )
}


module "dnf" {
  source = "../../../moduels/03.dns"
  zone_id = data.aws_route53_zone.zone.id
  name    = var.component
  type    = "A"
  ttl     = "5"
  records = [ aws_instance.bastion.public_ip ]
}