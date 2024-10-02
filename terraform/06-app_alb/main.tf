resource "aws_lb" "app_alb" {
  name               = "${var.common_tags.project}-${var.common_tags.env}-${var.common_tags.component}"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [ data.aws_ssm_parameter.app_alb_sg_id.value ]
  subnets            = split(",", data.aws_ssm_parameter.private_subnet_id.value)

  enable_deletion_protection = false

  tags = merge(
    var.common_tags,
    {
      Name = "${var.common_tags.project}-${var.common_tags.env}-${var.common_tags.component}"
    }
  )
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "<h1>This is Fixed response content</h1>"
      status_code  = "200"
    }
  }
}

resource "aws_ssm_parameter" "app_alb_listener_arn" {
  name        = "${var.common_tags.project}-${var.common_tags.env}-${var.common_tags.component}-app-alb-listener-arn"
  type        = "String"
  value       = aws_lb_listener.http.arn
  description = "ARN of the Application Load Balancer listener"

  tags = merge(
    var.common_tags,
    {
      Name = "${var.common_tags.project}-${var.common_tags.env}-${var.common_tags.component}-app-alb-listener-arn"
    }
  )
}

resource "cloudflare_record" "bastion" {
  zone_id = data.cloudflare_zone.zone.id
  name    = "*.app-${var.common_tags.env}"
  value   = aws_lb.app_alb.dns_name
  type    = "A"
  ttl     = 60
  proxied = false
  allow_overwrite = true

  # Lifecycle rules to create before destroying the old one
  lifecycle {
    create_before_destroy = true
  }
}
