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

