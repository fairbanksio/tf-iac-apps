resource "kubernetes_namespace" "bsord" {
  metadata {
    name = "bsord"
  }
}

resource "helm_release" "bsord-homepage" {
  repository = "https://h.cfcr.io/bsord/charts"
  chart      = "bsord-homepage"
  name       = "bsord-homepage"
  namespace  = "bsord"
  version = "0.4.0"
  set {
    name  = "ingress.enabled"
    value = "true"
  }
  set {
    name  = "autoscaling.enabled"
    value = true
  }
  set {
    name  = "autoscaling.minreplicas"
    value = 1
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
  value   = data.kubernetes_service.nginx-ingress-controller.status.0.load_balancer.0.ingress.0.ip
  type    = "A"
  ttl     = 1
}