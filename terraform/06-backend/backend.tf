# module "backend" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   name = "${var.project}-${var.env}-${var.component}"
#
#   instance_type          = "t3.micro"
#   vpc_security_group_ids = [data.aws_ssm_parameter.backend_sg_id.value]
#   # convert StringList to list and get first element
#   subnet_id = element(split(",", data.aws_ssm_parameter.private_subnet_id.value), 0)
#   ami = data.aws_ami.ami_info.id
#
#   tags = merge(
#     var.common_tags,
#     {
#       Name = "${var.project}-${var.env}-${var.component}"
#     }
#   )
# }

resource "aws_instance" "backend" {
  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.backend_sg_id.value]
  subnet_id = element(split(",", data.aws_ssm_parameter.private_subnet_id.value), 0)
  ami = data.aws_ami.ami_info.id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project}-${var.env}-${var.component}"
    }
  )
}


resource "null_resource" "backend" {
  triggers = {
    instance_id = aws_instance.backend.id
  }
  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.backend.private_ip
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

resource "aws_ec2_instance_state" "backend" {
  instance_id = aws_instance.backend.id
  state       = "stopped"
  # stop the serever only when null resource provisioning is completed
  depends_on = [ null_resource.backend ]
}

resource "aws_ami_from_instance" "backend" {
  name               = "${var.project}-${var.env}-${var.component}"
  source_instance_id = aws_instance.backend.id
  depends_on = [ aws_ec2_instance_state.backend ]
}

resource "null_resource" "backend_delete" {
  triggers = {
    instance_id = aws_instance.backend.id # this will be triggered everytime instance is created
  }

  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${aws_instance.backend.id}"
  }

  depends_on = [ aws_ami_from_instance.backend ]
}


resource "aws_lb_target_group" "backend" {
  name     = "${var.project}-${var.env}-${var.component}"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_ssm_parameter.vpc_id.value
  health_check {
    path                = "/health"
    port                = 8080
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_launch_template" "backend" {
  name = "${var.project}-${var.env}-${var.component}"

  image_id = aws_ami_from_instance.backend.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t3.micro"
  update_default_version = true # sets the latest version to default

  vpc_security_group_ids = [data.aws_ssm_parameter.backend_sg_id.value]

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.common_tags,
      {
        Name = "${var.project}-${var.env}-${var.component}"
      }
    )
  }
  depends_on = [ aws_ami_from_instance.backend ]
}

resource "aws_autoscaling_group" "backend" {
  name                      = "${var.project}-${var.env}-${var.component}"
  max_size                  = 5
  min_size                  = 1
  health_check_grace_period = 60
  health_check_type         = "ELB"
  desired_capacity          = 1
  target_group_arns         = [aws_lb_target_group.backend.arn]
  vpc_zone_identifier       = split(",", data.aws_ssm_parameter.private_subnet_id.value)
  depends_on = [
    aws_lb_target_group.backend,
    aws_launch_template.backend
  ]

  launch_template {
    id      = aws_launch_template.backend.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }

  tag {
    key                 = "Name"
    value               = "${var.project}-${var.env}-${var.component}"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }

  tag {
    key                 = "Project"
    value               = "${var.project}"
    propagate_at_launch = false
  }
}

resource "aws_autoscaling_policy" "backend" {
  name                   = "${var.project}-${var.env}-${var.component}"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.backend.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 10.0
  }
}


