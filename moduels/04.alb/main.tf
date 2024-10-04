resource "aws_lb" "app_alb" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = var.security_groups
  subnets            = var.subnets

  enable_deletion_protection = false

  tags = merge(
    var.common_tags,
    {
      Name = var.name
    }
  )
}