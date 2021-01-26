resource "kubernetes_namespace" "json-formatter" {
  metadata {
    name = "json-formatter"
  }
}

resource "helm_release" "json-formatter" {
  repository = "https://jonfairbanks.github.io/helm-charts"
  chart      = "json-formatter"
  name       = "json-formatter"
  namespace  = "json-formatter"
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
    value = cloudflare_record.json-formatter.hostname
  }
  set {
    name  = "ingress.hosts[0].paths[0]"
    value = "/"
  }
  set {
    name  = "image.tag"
    value = "0.1.0"
  }
}

resource "cloudflare_record" "json-formatter" {
  zone_id = var.cloudflare_zone_id
  name    = "json"
  proxied = true
  value   = data.kubernetes_service.nginx-ingress-controller.status.0.load_balancer.0.ingress.0.ip
  type    = "A"
  ttl     = 1
}