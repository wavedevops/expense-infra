
module "frontend" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  name = "${var.project}-${var.env}-${var.component}"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.frontend_sg_id.value]
  # convert StringList to list and get first element
  subnet_id = element(split(",", data.aws_ssm_parameter.private_subnet_id.value), 0)
  ami = data.aws_ami.ami_info.id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project}-${var.env}-${var.component}"
    }
  )
}


resource "null_resource" "frontend" {
  triggers = {
    instance_id = module.frontend.id # this will be triggered everytime instance is created
  }
  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = module.frontend.private_ip
  }
  provisioner "file" {
    source      = "${var.component}.sh"
    destination = "/tmp/${var.component}.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/${var.component}.sh",
      "sudo sh /tmp/${var.component}.sh ${var.component} ${var.env}"
    ]
  }
}

resource "aws_ec2_instance_state" "frontend" {
  instance_id = module.frontend.id
  state       = "stopped"
  # stop the serever only when null resource provisioning is completed
  depends_on = [ null_resource.frontend ]
}

# this script working fine. but re run new instance came and stop,  add condition of frontend module not create new instance because i stop that. not available that instance create new, not available men status terminate  then create new


resource "aws_ami_from_instance" "frontend" {
  name               = "${var.project}-${var.env}-${var.component}"
  source_instance_id = module.frontend.id
  depends_on = [ aws_ec2_instance_state.frontend ]
}

present not need then comment
resource "null_resource" "frontend_delete" {
  triggers = {
    instance_id = module.frontend.id # this will be triggered everytime instance is created
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = module.frontend.private_ip
  }

  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${module.frontend.id}"
  }

  depends_on = [ aws_ami_from_instance.frontend ]
}


