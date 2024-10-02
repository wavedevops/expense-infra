resource "cloudflare_record" "bastion" {
  zone_id = data.cloudflare_zone.zone.id
  name    = var.component
  content = aws_instance.vpn.public_ip
  type    = "A"
  ttl     = 60
  proxied = false
  allow_overwrite = true

  # Lifecycle rules to create before destroying the old one
  lifecycle {
    create_before_destroy = true
  }
}