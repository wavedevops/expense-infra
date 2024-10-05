module "alb_backend" {
  source             = "../../moduels/04.alb"
  name               = "${var.project}-${var.env}-${var.component}"
  internal           = "true"
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.app_alb_sg_id.value]
  subnets            = split(",", data.aws_ssm_parameter.private_subnet_id.value)
  common_tags        = var.common_tags
  depends_on         = [ null_resource.backend_delete ]
}

resource "cloudflare_record" "app_alb" {
  zone_id         = data.cloudflare_zone.zone.id
  name            = "*.app-${var.common_tags.env}"
  content         = module.alb_backend.dns_name
  type            = "CNAME"
  ttl             = 60
  proxied         = false
  allow_overwrite = true

  lifecycle {
    create_before_destroy = true
  }
}

