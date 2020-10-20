## Tiles

resource "kubernetes_namespace" "rcvr" {
  metadata {
    name = "rcvr"
  }
}

resource "helm_release" "tiles-api_pretty-default-backend" {
  name       = "pretty-default-backend"
  repository = "https://h.cfcr.io/fairbanks.io/default"
  chart      = "pretty-default-backend"
  namespace  = "rcvr"
  set {
    name  = "bgColor"
    value = "#202025"
  }
  set {
    name  = "brandingText"
    value = "https://github.com/bsord"
  }
}

resource "helm_release" "rcvr-web" {
  repository = "https://h.cfcr.io/bsord/charts"
  chart      = "rcvr-web"
  name       = "rcvr-web"
  namespace  = "rcvr"
  set {
    name  = "apiHost"
    value = cloudflare_record.rcvr-api.hostname
  }
  set {
    name  = "ingress.enabled"
    value = "true"
  }
  set {
    name  = "ingress.hosts[0].host"
    value = cloudflare_record.rcvr-web.hostname
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

resource "cloudflare_record" "rcvr-web" {
  zone_id = var.cloudflare_zone_id
  name    = "rcvr"
  proxied = true
  value   = data.kubernetes_service.nginx-ingress-controller.load_balancer_ingress.0.ip
  type    = "A"
  ttl     = 1
}

resource "helm_release" "rcvr-session-cache" {
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "redis"
  name       = "rcvr-session-cache"
  namespace  = "rcvr"
  set_sensitive {
    name  = "password"
    value = var.rcvr_redispassword
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

resource "helm_release" "rcvr-db" {
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mariadb"
  name       = "rcvr-db"
  namespace  = "rcvr"
  set_sensitive {
    name  = "auth.password"
    value = var.rcvr_dbpassword
  }
  set {
    name  = "auth.username"
    value = "rcvr"
  }
  set {
    name  = "auth.database"
    value = "rcvr"
  }
  set {
    name  = "primary.persistence.enabled"
    value = false
  }
  set {
    name  = "secondary.persistence.enabled"
    value = false
  }

}

resource "helm_release" "rcvr-relay" {
  repository = "https://bsord.github.io/helm-charts"
  chart      = "postfix"
  name       = "rcvr-relay"
  namespace  = "rcvr"
  
  set {
    name  = "allowedSenderDomains"
    value = "rcvr.io"
  }

}

resource "helm_release" "rcvr-api" {
  repository = "https://h.cfcr.io/bsord/charts"
  chart      = "rcvr-api"
  name       = "rcvr-api"
  namespace  = "rcvr"
  set {
    name  = "ingress.enabled"
    value = "true"
  }
  set {
    name  = "ingress.hosts[0].host"
    value = cloudflare_record.rcvr-api.hostname
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

resource "cloudflare_record" "rcvr-api" {
  zone_id = var.cloudflare_zone_id
  name    = "rcvr-api"
  proxied = true
  value   = data.kubernetes_service.nginx-ingress-controller.load_balancer_ingress.0.ip
  type    = "A"
  ttl     = 1
}