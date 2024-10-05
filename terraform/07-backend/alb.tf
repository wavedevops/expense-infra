module "alb_backend" {
  source             = "../../moduels/04.alb"
  name               = "${var.project}-${var.env}-${var.component}"
  internal           = "true"
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.app_alb_sg_id.value]
  subnets            = split(",", data.aws_ssm_parameter.private_subnet_id.value)
  common_tags        = var.common_tags
  depends_on         = [ aws_ami_from_instance.backend ]
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = module.alb_backend.lb_arn
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


resource "aws_lb_listener_rule" "backend" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }

  condition {
    host_header {
      values = ["backend.app-${var.env}.${data.cloudflare_zone.zone.name}"]
    }
  }
}

resource "cloudflare_record" "app_alb" {
  zone_id         = data.cloudflare_zone.zone.id
  name            = "*.app-${var.common_tags.env}"
  content         = module.alb_backend.dns_name
  type            = "CNAME"
  ttl             = 60
  proxied         = false
  allow_overwrite = true

  lifecycle {
    create_before_destroy = true
  }
}
