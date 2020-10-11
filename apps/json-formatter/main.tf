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
  zone_id = var.cloudflare_zone_id_fairbanks
  name    = "json"
  proxied = true
  value   = data.kubernetes_service.nginx-ingress-controller.load_balancer_ingress.0.ip
  type    = "A"
  ttl     = 1
}