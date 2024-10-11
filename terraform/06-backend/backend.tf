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

  image_id = data.aws_ami.backend_ami.id
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
}


resource "aws_autoscaling_group" "backend" {
  name                      = "${var.project}-${var.env}-${var.component}"
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

resource "aws_lb_listener_rule" "backend" {
  listener_arn = data.aws_ssm_parameter.app_alb_listener_arn.value
  priority     = 100 # less number will be first validated

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }

  condition {
    host_header {
      values = ["backend.app-${var.env}.${data.aws_route53_zone.zone.name}"]
    }
  }
}