resource "kubernetes_namespace" "mealie" {
  metadata {
    name = "mealie"
  }
}

resource "helm_release" "mealie" {
  repository = "https://jonfairbanks.github.io/helm-charts"
  chart      = "mealie"
  name       = "mealie"
  namespace  = "mealie"
  version = "1.0.1"
  set {
    name  = "minAvailable"
    value = 1
  }
  set {
    name  = "autoscaling.enabled"
    value = true
  }
  set {
    name  = "autoscaling.minReplicas"
    value = 2
  }
  set {
    name  = "autoscaling.maxReplicas"
    value = 3
  }
  set {
    name  = "ingress.hosts[0].host"
    value = cloudflare_record.mealie.hostname
  }
  set {
    name  = "ingress.hosts[0].paths[0]"
    value = "/"
  }
  set {
    name  = "resources.requests.cpu"
    value = "100m"
  }
  set {
    name  = "image.tag"
    value = "0.3.0"
  }
}

resource "cloudflare_record" "mealie" {
  zone_id = var.cloudflare_zone_id
  name    = "food"
  proxied = true
  value   = data.kubernetes_service.nginx-ingress-controller.status.0.load_balancer.0.ingress.0.ip
  type    = "A"
  ttl     = 1
}