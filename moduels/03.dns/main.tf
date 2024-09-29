resource "cloudflare_record" "app" {
  zone_id = var.zone_id
  name    = var.component
  content = var.dns_record
  type    = var.record_type
  ttl     = 60
  proxied = false
}




# resource "cloudflare_record" "app" {
#   zone_id = data.cloudflare_zone.zone.id
#   name    = var.component
#   value   = module.bastion.public_ip
#   type    = "A"
#   ttl     = 1
#   proxied = false
# }
