## Nextcloud

resource "kubernetes_namespace" "nextcloud" {
  metadata {
    name = "nextcloud"
  }
}

resource "helm_release" "nextcloud" {
  name       = "nextcloud"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "nextcloud"
  namespace  = "nextcloud"
  set {
    name  = "ingress.enabled"
    value = "true"
  }
  set {
    name  = "nextcloud.host"
    value = cloudflare_record.files.hostname
  }
  set {
    name  = "ingress.hosts[0].paths[0]"
    value = "/"
  }
  set {
    name  = "volumePermissions.enabled"
    value = "true"
  }
  set {
    name  = "externalDatabase.enabled"
    value = "true"
  }
  set {
    name  = "externalDatabase.host"
    value = var.nextcloud_mariadb_host
  }
  set {
    name  = "externalDatabase.user"
    value = var.nextcloud_mariadb_user
  }
  set {
    name  = "externalDatabase.password"
    value = var.nextcloud_mariadb_password
  }
  set {
    name  = "internalDatabase.enabled"
    value = "false"
  }
  set {
    name  = "persistence.enabled"
    value = "true"
  }
}

resource "cloudflare_record" "files" {
  zone_id = var.cloudflare_zone_id_fairbanks
  name    = "files"
  proxied = true
  value   = data.kubernetes_service.nginx-ingress-controller.load_balancer_ingress.0.ip
  type    = "A"
  ttl     = 1
}

## Tiles

resource "kubernetes_namespace" "tiles" {
  metadata {
    name = "bsord-tiles"
  }
}

resource "helm_release" "tiles-api_pretty-default-backend" {
  name       = "pretty-default-backend"
  repository = "https://h.cfcr.io/fairbanks.io/default"
  chart      = "pretty-default-backend"
  namespace  = "bsord-tiles"
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
  repository = "https://bsord.github.io/helm-charts"
  chart      = "tiles-client"
  name       = "tiles-client"
  namespace  = "bsord-tiles"
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
  repository = "https://bsord.github.io/helm-charts"
  chart      = "tiles-api"
  name       = "tiles-api"
  namespace  = "bsord-tiles"
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

# PayPal Sandbox Dashboard

resource "kubernetes_namespace" "paypal-sandbox-dashboard" {
  metadata {
    name = "paypal-sandbox-dashboard"
  }
}

resource "helm_release" "paypal-sandbox-dashboard" {
  repository = "https://Fairbanks-io.github.io/helm-charts"
  chart      = "paypal-sandbox-dashboard"
  name       = "paypal-sandbox-dashboard"
  namespace  = "paypal-sandbox-dashboard"
  set_sensitive {
    name  = "mongoURI"
    value = var.ppsandbox_mongouri
  }
  set {
    name  = "ingress.enabled"
    value = "true"
  }
  set {
    name  = "ingress.hosts[0].host"
    value = cloudflare_record.paypal-sandbox-dashboard.hostname
  }
  set {
    name  = "ingress.hosts[0].paths[0]"
    value = "/"
  }
}

resource "cloudflare_record" "paypal-sandbox-dashboard" {
  zone_id = var.cloudflare_zone_id
  name    = "sandbox"
  proxied = true
  value   = data.kubernetes_service.nginx-ingress-controller.load_balancer_ingress.0.ip
  type    = "A"
  ttl     = 1
}

## Sonny

resource "kubernetes_namespace" "sonny" {
  metadata {
    name = "sonny"
  }
}

resource "helm_release" "sonny" {
  repository = "https://bsord.github.io/helm-charts"
  chart      = "sonny"
  name       = "sonny"
  namespace  = "sonny"
  set_sensitive {
    name  = "HUBOT_SLACK_TOKEN"
    value = var.hubot_slack_token_sonny
  }
}