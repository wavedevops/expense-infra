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
      values = ["backend.app-${var.env}.${data.aws_route53_zone.zone.name}"]
    }
  }
}

# resource "aws_route53_record" "record" {
#   zone_id = data.aws_route53_zone.zone.id
#   name    = "*.app-${var.env}"
#   type    = "A"
#   alias {
#     name    = module.alb_backend.dns_name
#     zone_id = module.alb_backend.zone_id
#   }
#   allow_overwrite = true
# }

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = data.aws_route53_zone.zone.name

  records = [
    {
      name            = "*.app-${var.env}"
      type            = "A"
      allow_overwrite = true
      alias = {
        name    = module.alb_backend.dns_name
        zone_id = module.alb_backend.zone_id
      }
    }
  ]
}