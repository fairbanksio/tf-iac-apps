resource "kubernetes_namespace" "tetris" {
  metadata {
    name = "tetris"
  }
}

resource "helm_release" "tetris_pretty-default-backend" {
  name       = "pretty-default-backend"
  repository = "https://h.cfcr.io/bsord/charts"
  chart      = "pretty-default-backend"
  namespace  = "tetris"
  set {
    name  = "autoscaling.enabled"
    value = true
  }
  set {
    name  = "bgColor"
    value = "#202025"
  }
  set {
    name  = "brandingText"
    value = "https://github.com/bsord/tetris"
  }
}

resource "helm_release" "tetris" {
  repository = "https://bsord.github.io/helm-charts"
  chart      = "tetris"
  name       = "tetris"
  namespace  = "tetris"
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
    value = cloudflare_record.tetris.hostname
  }
  set {
    name  = "ingress.hosts[0].paths[0]"
    value = "/"
  }
  set {
    name  = "ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/default-backend"
    value = "pretty-default-backend"
    type  = "string"
  }
  set {
    name  = "ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/custom-http-errors"
    value = "404\\,503\\,501"
    type  = "string"
  }
}

resource "cloudflare_record" "tetris" {
  zone_id = var.cloudflare_zone_id
  name    = "tetris"
  proxied = true
  value   = data.kubernetes_service.nginx-ingress-controller.load_balancer_ingress.0.ip
  type    = "A"
  ttl     = 1
}