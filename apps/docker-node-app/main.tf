resource "kubernetes_namespace" "docker-node-app" {
  metadata {
    name = "docker-node-app"
  }
}

resource "helm_release" "docker-node-app" {
  repository = "https://jonfairbanks.github.io/helm-charts"
  chart      = "docker-node-app"
  name       = "docker-node-app"
  namespace  = "docker-node-app"
  set {
    name  = "ingress.hosts[0].host"
    value = cloudflare_record.kube.hostname
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
    value = "2.0.4"
  }
}

resource "cloudflare_record" "kube" {
  zone_id = var.cloudflare_zone_id
  name    = "kube"
  proxied = true
  value   = data.kubernetes_service.nginx-ingress-controller.load_balancer_ingress.0.ip
  type    = "A"
  ttl     = 1
}