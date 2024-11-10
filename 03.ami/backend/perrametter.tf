resource "aws_ssm_parameter" "app_alb_listener_arn" {
  name  = "/${var.project_name}/${var.common_tags.Component}/ami"
  type  = "String"
  value = aws_ami_from_instance.backend.id
}