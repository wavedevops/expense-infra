resource "aws_instance" "backend" {
  ami           = data.aws_ami.ami_info.id
  instance_type = "t3.micro"
  subnet_id = element(split(",", data.aws_ssm_parameter.private_subnet_id.value), 0)
  vpc_security_group_ids = [data.aws_ssm_parameter.backend_sg_id.value]

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

  provisioner "file" {
    source      = "${var.common_tags.Component}.sh"
    destination = "/tmp/${var.common_tags.Component}.sh"

    connection {
      type     = "ssh"
      user     = "ec2-user"
      password = "DevOps321"
      host     = aws_instance.backend.private_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/${var.common_tags.Component}.sh",
      "sudo sh /tmp/${var.common_tags.Component}.sh ${var.common_tags.Component} ${var.common_tags.env}"
    ]

    connection {
      type     = "ssh"
      user     = "ec2-user"
      password = "DevOps321"
      host     = aws_instance.backend.private_ip
    }
  }
}

resource "aws_ec2_instance_state" "stop_backend" {
  instance_id = aws_instance.backend.id
  state       = "stopped"  # Set the desired state to "stopped".

  depends_on = [ null_resource.backend ]
}

resource "aws_ami_from_instance" "backend" {
  name               = "${var.common_tags.project}-${var.common_tags.env}-${var.common_tags.component}"
  source_instance_id = aws_instance.backend.id
  depends_on = [ aws_ec2_instance_state.stop_backend ]
}


resource "null_resource" "backend_delete" {
  triggers = {
    instance_id = aws_instance.backend.id  # This will trigger every time the instance is created.
  }

  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${aws_instance.backend.id}"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Instance ${aws_instance.backend.id} is being terminated.'"
    ]

    connection {
      type     = "ssh"
      user     = "ec2-user"
      password = "DevOps321"
      host     = aws_instance.backend.private_ip
    }
  }

  # Ensure the deletion only happens after the AMI creation is complete.
  depends_on = [aws_ami_from_instance.backend]
}

resource "aws_lb_target_group" "backend" {
  name     = "${var.common_tags.project}-${var.common_tags.env}-${var.common_tags.component}"
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
  name = "${var.common_tags.project}-${var.common_tags.env}-${var.common_tags.component}"

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
        Name = "${var.common_tags.project}-${var.common_tags.env}-${var.common_tags.component}"
      }
    )
  }
}

resource "aws_autoscaling_group" "backend" {
  name                      = "${var.common_tags.project}-${var.common_tags.env}-${var.common_tags.component}"
  max_size                  = 5
  min_size                  = 1
  health_check_grace_period = 60
  health_check_type         = "ELB"
  desired_capacity          = 1
  target_group_arns = [aws_lb_target_group.backend.arn]
  launch_template {
    id      = aws_launch_template.backend.id
    version = "$Latest"
  }
  vpc_zone_identifier       = split(",", data.aws_ssm_parameter.private_subnet_id.value)

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }

  tag {
    key                 = "Name"
    value               = "${var.common_tags.project}-${var.common_tags.env}-${var.common_tags.component}"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }

  tag {
    key                 = "Project"
    value               = "${var.common_tags.project}"
    propagate_at_launch = false
  }
}

resource "aws_autoscaling_policy" "backend" {
  name                   = "${var.common_tags.project}-${var.common_tags.env}-${var.common_tags.component}"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.backend.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 10.0
  }
}

resource "aws_lb_listener_rule" "backend" {
  listener_arn = data.aws_ssm_parameter.app_alb_listener_arn.value
  priority     = 100 # less number will be first validated

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }

  condition {
    host_header {
      values = ["backend.app-${var.environment}.${var.zone_name}"]
    }
  }
}