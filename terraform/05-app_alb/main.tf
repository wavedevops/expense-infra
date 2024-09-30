resource "aws_lb" "app_alb" {
  name               = "${var.common_tags.Project}-${var.common_tags.env}-${var.common_tags.Component}"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.app_alb_sg_id.value]
  subnets            = split(",", data.aws_ssm_parameter.private_subnet_id.value )

  enable_deletion_protection = false

  tags =merge(
    var.common_tags,
    {
      Name = "${var.common_tags.Project}-${var.common_tags.env}-${var.common_tags.Component}"
    }
  )
}