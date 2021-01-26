resource "kubernetes_namespace" "jonfairbanks" {
  metadata {
    name = "jonfairbanks"
  }
}

resource "helm_release" "jonfairbanks-homepage" {
  repository = "https://jonfairbanks.github.io/helm-charts"
  chart      = "jonfairbanks-homepage"
  name       = "jonfairbanks-homepage"
  namespace  = "jonfairbanks"
  version = "1.1.0"
  set {
    name  = "autoscaling.enabled"
    value = true
  }
  set {
    name  = "ingress.enabled"
    value = "true"
  }
  set {
    name  = "ingress.hosts[0].host"
    value = cloudflare_record.jonfairbanks-homepage.hostname
  }
  set {
    name  = "ingress.hosts[0].paths[0]"
    value = "/"
  }
}

resource "cloudflare_record" "jonfairbanks-homepage" {
  zone_id = var.cloudflare_zone_id
  name    = "@"
  proxied = true
  value   = data.kubernetes_service.nginx-ingress-controller.status.0.load_balancer.0.ingress.0.ip
  type    = "A"
  ttl     = 1
}