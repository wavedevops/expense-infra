resource "aws_instance" "frontend" {
  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.frontend_sg_id.value]
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
    instance_id = aws_instance.frontend.id
  }
  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.frontend.private_ip
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
  instance_id = aws_instance.frontend.id
  state       = "stopped"
  # stop the serever only when null resource provisioning is completed
  depends_on = [ null_resource.frontend ]
}

resource "aws_ami_from_instance" "frontend" {
  name               = "${var.project}-${var.env}-${var.component}"
  source_instance_id = aws_instance.frontend.id
  depends_on = [ aws_ec2_instance_state.frontend ]
}

resource "null_resource" "frontend_delete" {
  triggers = {
    instance_id = aws_instance.frontend.id # this will be triggered everytime instance is created
  }

  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${aws_instance.frontend.id}"
  }

  depends_on = [ aws_ami_from_instance.frontend ]
}


resource "aws_lb_target_group" "frontend" {
  name     = "${var.project}-${var.env}-${var.component}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_ssm_parameter.vpc_id.value
  health_check {
    path                = "/health"
    port                = 80
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_launch_template" "frontend" {
  name = "${var.project}-${var.env}-${var.component}"

  image_id = aws_ami_from_instance.frontend.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t3.micro"
  update_default_version = true # sets the latest version to default

  vpc_security_group_ids = [data.aws_ssm_parameter.frontend_sg_id.value]

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.common_tags,
      {
        Name = "${var.project}-${var.env}-${var.component}"
      }
    )
  }
  depends_on = [ aws_ami_from_instance.frontend ]
}

resource "aws_autoscaling_group" "frontend" {
  name                      = "${var.project}-${var.env}-${var.component}"
  max_size                  = 5
  min_size                  = 1
  health_check_grace_period = 60
  health_check_type         = "ELB"
  desired_capacity          = 1
  target_group_arns         = [aws_lb_target_group.frontend.arn]
  vpc_zone_identifier       = split(",", data.aws_ssm_parameter.private_subnet_id.value)
  depends_on = [
    aws_lb_target_group.frontend,
    aws_launch_template.frontend
  ]

  launch_template {
    id      = aws_launch_template.frontend.id
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

resource "aws_autoscaling_policy" "frontend" {
  name                   = "${var.project}-${var.env}-${var.component}"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.frontend.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 10.0
  }
}


