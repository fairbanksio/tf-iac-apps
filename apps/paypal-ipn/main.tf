resource "kubernetes_namespace" "paypal-ipn" {
  metadata {
    name = "paypal-ipn"
  }
}

resource "helm_release" "paypal-ipn" {
  repository = "https://Fairbanks-io.github.io/helm-charts"
  chart      = "paypal-ipn"
  name       = "paypal-ipn"
  namespace  = "paypal-ipn"
  set_sensitive {
    name  = "mongoURI"
    value = var.ppipn_mongouri
  }
  set {
    name  = "ingress.enabled"
    value = "true"
  }
  set {
    name  = "ingress.hosts[0].host"
    value = cloudflare_record.paypal-ipn.hostname
  }
  set {
    name  = "ingress.hosts[0].paths[0]"
    value = "/"
  }
  set {
    name  = "image.tag"
    value = "1.0.2"
  }
}

resource "cloudflare_record" "paypal-ipn" {
  zone_id = var.cloudflare_zone_id
  name    = "ipn"
  proxied = true
  value   = data.kubernetes_service.nginx-ingress-controller.load_balancer_ingress.0.ip
  type    = "A"
  ttl     = 1
}