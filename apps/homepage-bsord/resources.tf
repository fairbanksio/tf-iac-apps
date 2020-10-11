resource "kubernetes_namespace" "bsord" {
  metadata {
    name = "bsord"
  }
}

resource "helm_release" "bsord-homepage" {
  repository = "https://h.cfcr.io/fairbanks.io/default"
  chart      = "bsord-homepage"
  name       = "bsord-homepage"
  namespace  = "bsord"
  set {
    name  = "ingress.enabled"
    value = "true"
  }
  set {
    name  = "ingress.hosts[0].host"
    value = cloudflare_record.bsord-homepage.hostname
  }
  set {
    name  = "ingress.hosts[0].paths[0]"
    value = "/"
  }
}

resource "cloudflare_record" "bsord-homepage" {
  zone_id = var.cloudflare_zone_id
  name    = "@"
  proxied = true
  value   = data.kubernetes_service.nginx-ingress-controller.load_balancer_ingress.0.ip
  type    = "A"
  ttl     = 1
}