## Tiles

resource "kubernetes_namespace" "tiles" {
  metadata {
    name = "bsord-tiles"
  }
}

resource "helm_release" "tiles-api_pretty-default-backend" {
  name       = "pretty-default-backend"
  repository = "https://h.cfcr.io/bsord/charts"
  chart      = "pretty-default-backend"
  namespace  = "bsord-tiles"
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
    value = "https://github.com/bsord"
  }
}

resource "helm_release" "tiles-client" {
  repository = "https://h.cfcr.io/bsord/charts"
  chart      = "tiles-client"
  name       = "tiles-client"
  namespace  = "bsord-tiles"
  set {
    name  = "autoscaling.enabled"
    value = true
  }
  set {
    name  = "apiHost"
    value = cloudflare_record.tiles-api.hostname
  }
  set {
    name  = "ingress.enabled"
    value = "true"
  }
  set {
    name  = "ingress.hosts[0].host"
    value = cloudflare_record.tiles-client.hostname
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

resource "cloudflare_record" "tiles-client" {
  zone_id = var.cloudflare_zone_id
  name    = "tiles"
  proxied = true
  value   = data.kubernetes_service.nginx-ingress-controller.load_balancer_ingress.0.ip
  type    = "A"
  ttl     = 1
}

## Tiles-API

resource "helm_release" "tiles-api" {
  repository = "https://h.cfcr.io/bsord/charts"
  chart      = "tiles-api"
  name       = "tiles-api"
  namespace  = "bsord-tiles"
  set {
    name  = "autoscaling.enabled"
    value = true
  }
  set_sensitive {
    name  = "mongoURI"
    value = var.tiles-api_mongouri
  }
  set {
    name  = "redisHost"
    value = var.tiles-api_redishost
  }
  set_sensitive {
    name  = "redisPassword"
    value = var.tiles-api_redispassword
  }
  set {
    name  = "ingress.enabled"
    value = "true"
  }
  set {
    name  = "ingress.hosts[0].host"
    value = cloudflare_record.tiles-api.hostname
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

resource "cloudflare_record" "tiles-api" {
  zone_id = var.cloudflare_zone_id
  name    = "tiles-api"
  proxied = true
  value   = data.kubernetes_service.nginx-ingress-controller.load_balancer_ingress.0.ip
  type    = "A"
  ttl     = 1
}

resource "helm_release" "tiles-session-cache" {
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "redis"
  name       = "tiles-session-cache"
  namespace  = "bsord-tiles"
  set_sensitive {
    name  = "password"
    value = var.tiles-api_redispassword
  }
  set {
    name  = "master.persistence.enabled"
    value = false
  }
  set {
    name  = "slave.persistence.enabled"
    value = false
  }
  set {
    name  = "cluster.slaveCount"
    value = 1
  }
}