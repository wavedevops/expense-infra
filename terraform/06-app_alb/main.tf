resource "aws_lb" "app_alb" {
  name               = "${var.project}-${var.env}-${var.component}"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [ data.aws_ssm_parameter.app_alb_sg_id.value ]
  subnets            = split(",", data.aws_ssm_parameter.private_subnet_id.value)

  enable_deletion_protection = false

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project}-${var.env}-${var.component}"
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
      content_type = "text/html"
      message_body = "<h1>This is Fixed response content hari</h1>"
      status_code  = "200"
    }
  }
}

resource "aws_ssm_parameter" "app_alb_listener_arn" {
  name        = "${var.project}-${var.env}-${var.component}-app-alb-listener-arn"
  type        = "String"
  value       = aws_lb_listener.http.arn
  description = "ARN of the Application Load Balancer listener"

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project}-${var.env}-${var.component}-app-alb-listener-arn"
    }
  )
}
## https://44.192.97.148:943/
resource "cloudflare_record" "app_alb" {
  zone_id = data.cloudflare_zone.zone.id
  name    = "*.app-${var.common_tags.env}"
  content = aws_lb.app_alb.dns_name
  type    = "CNAME"
  ttl     = 60
  proxied = false
  allow_overwrite = true

  lifecycle {
    create_before_destroy = true
  }
}
