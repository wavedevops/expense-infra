resource "aws_key_pair" "vpn" {
  key_name   = "openvpn"
  public_key = file("~/.ssh/openvpn.pub")
}

resource "aws_instance" "vpn" {

  key_name = aws_key_pair.vpn.key_name
  ami           = data.aws_ami.ami_info.id
  instance_type = var.instance_type
  subnet_id = element(split(",", data.aws_ssm_parameter.public_subnet_id.value), 0)
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]


  tags = merge(
    var.common_tags,
    {
      Name = "${var.project}-${var.env}-${var.component}"
    }
  )
}

