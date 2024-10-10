module "alb_frontend" {
  source             = "../../moduels/04.alb"
  name               = "${var.project}-${var.env}-${var.component}"
  internal           = "false"
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.app_alb_sg_id.value]
  subnets            = split(",", data.aws_ssm_parameter.public_subnet_id.value)
  common_tags        = var.common_tags
  depends_on         = [ aws_ami_from_instance.frontend ]
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = module.alb_frontend.lb_arn
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

resource "aws_lb_listener" "https" {
  load_balancer_arn = module.alb_frontend.lb_arn
  port              = "443"

  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.expense.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>This is fixed response from Web ALB HTTPS</h1>"
      status_code  = "200"
    }
  }
}
resource "aws_lb_listener_rule" "frontend" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }

  condition {
    host_header {
      values = ["frontend.app-${var.env}.${data.aws_route53_zone.zone.name}"]
    }
  }
}


# terraform init && terraform plan -target=aws_route53_record.app_record
# resource "aws_route53_record" "app_record" {
#   zone_id = data.aws_route53_zone.zone.zone_id
#   name    = "*.app-${var.env}"
#   type    = "CNAME"
#   allow_overwrite = true
#
#   alias {
#     name                   = module.alb_frontend.dns_name
#     zone_id                = module.alb_frontend.zone_id
#     evaluate_target_health = false
#   }
# }


module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = data.aws_route53_zone.zone.name

  records = [
    {
      name    = "web-${var.env}"
      type    = "A"
      allow_overwrite = true
      alias   = {
        name    = module.alb_frontend.dns_name
        zone_id = module.alb_frontend.zone_id
      }
    }
  ]
}