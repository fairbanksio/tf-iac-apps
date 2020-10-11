resource "kubernetes_namespace" "markdown-editor" {
  metadata {
    name = "markdown-editor"
  }
}

resource "helm_release" "markdown-editor" {
  repository = "https://jonfairbanks.github.io/helm-charts"
  chart      = "markdown-editor"
  name       = "markdown-editor"
  namespace  = "markdown-editor"
  set {
    name  = "ingress.enabled"
    value = "true"
  }
  set {
    name  = "ingress.hosts[0].host"
    value = cloudflare_record.markdown-editor.hostname
  }
  set {
    name  = "ingress.hosts[0].paths[0]"
    value = "/"
  }
  set {
    name  = "image.tag"
    value = "0.1.1"
  }
}

resource "cloudflare_record" "markdown-editor" {
  zone_id = var.cloudflare_zone_id_fairbanks
  name    = "md"
  proxied = true
  value   = data.kubernetes_service.nginx-ingress-controller.load_balancer_ingress.0.ip
  type    = "A"
  ttl     = 1
}