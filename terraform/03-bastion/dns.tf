resource "cloudflare_record" "bastion" {
  zone_id = data.cloudflare_zone.zone.id
  name    = var.component
  content = module.bastion.private_ip  # Use the private IP from the EC2 instance module
  type    = "A"
  ttl     = 60
  proxied = false
  allow_overwrite = true

  # Lifecycle rules to create before destroying the old one
  lifecycle {
    create_before_destroy = true
  }
}