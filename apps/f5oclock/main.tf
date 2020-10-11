resource "kubernetes_namespace" "f5oclock" {
  metadata {
    name = "f5oclock"
  }
}

resource "helm_release" "f5-api" {
  repository = "https://jonfairbanks.github.io/helm-charts"
  chart      = "f5-api"
  name       = "f5-api"
  namespace  = "f5oclock"
  set_sensitive {
    name  = "MONGO_URI"
    value = var.f5_mongo_uri
  }
  set {
    name  = "image.tag"
    value = "1.0.0"
  }
}

resource "helm_release" "f5-web" {
  repository = "https://jonfairbanks.github.io/helm-charts"
  chart      = "f5-web"
  name       = "f5-web"
  namespace  = "f5oclock"
  set {
    name  = "ingress.enabled"
    value = "true"
  }
  set {
    name  = "ingress.hosts[0].host"
    value = cloudflare_record.f5-web.hostname
  }
  set {
    name  = "ingress.hosts[0].paths[0]"
    value = "/"
  }
  set_sensitive {
    name  = "MONGO_URI"
    value = var.f5_mongo_uri
  }
  set {
    name  = "image.tag"
    value = "1.0.1"
  }
}

resource "cloudflare_record" "f5-web" {
  zone_id = var.cloudflare_zone_id
  name    = "f5"
  proxied = true
  value   = data.kubernetes_service.nginx-ingress-controller.load_balancer_ingress.0.ip
  type    = "A"
  ttl     = 1
}