resource "cloudflare_record" "status-fairbanks" {
  zone_id = var.cloudflare_zone_id
  name    = "status"
  proxied = false
  value   = "stats.uptimerobot.com"
  type    = "CNAME"
  ttl     = 1
}