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
  version = "1.1.0"
  set {
    name  = "autoscaling.enabled"
    value = true
  }
  set {
    name  = "autoscaling.minReplicas"
    value = 2
  }
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
  zone_id = var.cloudflare_zone_id
  name    = "md"
  proxied = true
  value   = data.kubernetes_service.nginx-ingress-controller.status.0.load_balancer.0.ingress.0.ip
  type    = "A"
  ttl     = 1
}