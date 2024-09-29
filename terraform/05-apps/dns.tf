resource "cloudflare_record" "frontend" {
  zone_id = data.cloudflare_zone.zone.id
  name    = "frontend"
  content = module.frontend.private_ip
  type    = "A"
  ttl     = 60
  proxied = false

  lifecycle {
    create_before_destroy = true
  }
}

resource "cloudflare_record" "backend" {
  zone_id = data.cloudflare_zone.zone.id
  name    = "backend"
  content = module.backend.private_ip
  type    = "A"
  ttl     = 60
  proxied = false

  lifecycle {
    create_before_destroy = true
  }
}

# resource "cloudflare_record" "ansible" {
#   zone_id = data.cloudflare_zone.zone.id
#   name    = "ansible"
#   content = module.ansible.public_ip
#   type    = "A"
#   ttl     = 60
#   proxied = false
#
#   lifecycle {
#     create_before_destroy = true
#   }
# }

