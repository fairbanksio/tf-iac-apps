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
  version = "1.2.0"
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
    name  = "limits.cpu"
    value = "100m"
  }
  set {
    name  = "f5.secretName"
    value = "f5-mongouri"
  }
  set_sensitive {
    name  = "f5.mongoUri"
    value = var.f5_mongo_uri
  }
  set {
    name  = "autoscaling.enabled"
    value = true
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

resource "helm_release" "f5-web" {
  repository = "https://jonfairbanks.github.io/helm-charts"
  chart      = "f5-web"
  name       = "f5-web"
  namespace  = "f5oclock"
  version = "1.1.4"
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
    name  = "limits.cpu"
    value = "100m"
  }
  set {
    name  = "f5.secretName"
    value = "f5-mongouri"
  }
  set_sensitive {
    name  = "f5.mongoUri"
    value = var.f5_mongo_uri
  }
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
    value = "1.0.2"
  }
}

resource "cloudflare_record" "f5-web" {
  zone_id = var.cloudflare_zone_id
  name    = "f5"
  proxied = true
  value   = data.kubernetes_service.nginx-ingress-controller.status.0.load_balancer.0.ingress.0.ip
  type    = "A"
  ttl     = 1
}