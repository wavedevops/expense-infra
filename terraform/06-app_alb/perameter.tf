resource "aws_ssm_parameter" "frontend" {
  name  = "/${var.project}/${var.env}/app_alb_listener_arn"
  type  = "String"
  value = module.alb_backend.lb_arn
}
