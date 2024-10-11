resource "aws_ssm_parameter" "bastion" {
  name  = "/${var.project}/${var.env}/app_alb_listener_arn"
  type  = "String"
  value = aws_lb_listener.http.arn
}