output "lb_arn" {
  value = aws_lb.app_alb.arn
}
output "dns_name" {
  value = aws_lb.app_alb.dns_name
}