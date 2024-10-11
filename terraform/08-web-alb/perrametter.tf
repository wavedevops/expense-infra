resource "aws_ssm_parameter" "web_alb_listener_arn" {
  name  = "/${var.project}/${var.env}/web_alb_listener_arn"
  type  = "String"
  value = aws_lb_listener.http.arn
}

resource "aws_ssm_parameter" "web_alb_listener_arn_https" {
  name  = "/${var.project}/${var.env}/web_alb_listener_arn_https"
  type  = "String"
  value = aws_lb_listener.https.arn
}