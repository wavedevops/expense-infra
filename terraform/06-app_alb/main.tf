# module "alb_backend" {
#   source             = "../../moduels/04.alb"
#   name               = "${var.project}-${var.env}-${var.component}"
#   internal           = "true"
#   load_balancer_type = "application"
#   security_groups    = [data.aws_ssm_parameter.app_alb_sg_id.value]
#   subnets            = split(",", data.aws_ssm_parameter.private_subnet_id.value)
#   common_tags        = var.common_tags
# }
#
# resource "cloudflare_record" "app_alb" {
#   zone_id         = data.cloudflare_zone.zone.id
#   name            = "*.app-${var.common_tags.env}"
#   content         = module.alb_backend.dns_name
#   type            = "CNAME"
#   ttl             = 60
#   proxied         = false
#   allow_overwrite = true
#
#   lifecycle {
#     create_before_destroy = true
#   }
# }
# resource "aws_lb_listener" "http" {
#   load_balancer_arn = module.alb_backend.lb_arn
#   port              = "80"
#   protocol          = "HTTP"
#   default_action {
#     type = "fixed-response"
#
#     fixed_response {
#       content_type = "text/html"
#       message_body = "<h1>This is Fixed response content hari</h1>"
#       status_code  = "200"
#     }
#   }
# }
#
#
# ## https://vpn.chowdary.cloud:943/admin
# ## https://18.207.107.3:943/
#
#
#
#
#
#
#
#
#
# # resource "aws_lb" "app_alb" {
# #   name               = "${var.project}-${var.env}-${var.component}"
# #   internal           = true
# #   load_balancer_type = "application"
# #   security_groups    = [ data.aws_ssm_parameter.app_alb_sg_id.value ]
# #   subnets            = split(",", data.aws_ssm_parameter.private_subnet_id.value)
# #
# #   enable_deletion_protection = false
# #
# #   tags = merge(
# #     var.common_tags,
# #     {
# #       Name = "${var.project}-${var.env}-${var.component}"
# #     }
# #   )
# # }
