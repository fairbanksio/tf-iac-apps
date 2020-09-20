## Home Pages

resource "kubernetes_namespace" "jonfairbanks" {
  metadata {
    name = "jonfairbanks"
  }
}

resource "helm_release" "jonfairbanks-homepage" {
  repository = "https://jonfairbanks.github.io/helm-charts"
  chart      = "jonfairbanks-homepage"
  name       = "jonfairbanks-homepage"
  namespace  = "jonfairbanks"
  set {
    name  = "ingress.enabled"
    value = "true"
  }
  set {
    name  = "ingress.hosts[0].host"
    value = cloudflare_record.jonfairbanks-homepage.hostname
  }
  set {
    name  = "ingress.hosts[0].paths[0]"
    value = "/"
  }
}

resource "cloudflare_record" "jonfairbanks-homepage" {
  zone_id = var.cloudflare_zone_id_fairbanks
  name    = "@"
  proxied = true
  value   = data.kubernetes_service.nginx-ingress-controller.load_balancer_ingress.0.ip
  type    = "A"
  ttl     = 1
}

resource "kubernetes_namespace" "bsord" {
  metadata {
    name = "bsord"
  }
}

resource "helm_release" "bsord-homepage" {
  repository = "https://h.cfcr.io/fairbanks.io/default"
  chart      = "bsord-homepage"
  name       = "bsord-homepage"
  namespace  = "bsord"
  set {
    name  = "ingress.enabled"
    value = "true"
  }
  set {
    name  = "ingress.hosts[0].host"
    value = cloudflare_record.bsord-homepage.hostname
  }
  set {
    name  = "ingress.hosts[0].paths[0]"
    value = "/"
  }
}

resource "cloudflare_record" "bsord-homepage" {
  zone_id = var.cloudflare_zone_id
  name    = "@"
  proxied = true
  value   = data.kubernetes_service.nginx-ingress-controller.load_balancer_ingress.0.ip
  type    = "A"
  ttl     = 1
}

## Status Pages

resource "cloudflare_record" "status" {
  zone_id = var.cloudflare_zone_id
  name    = "status"
  proxied = false
  value   = "stats.uptimerobot.com"
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_record" "status-fairbanks" {
  zone_id = var.cloudflare_zone_id_fairbanks
  name    = "status"
  proxied = false
  value   = "stats.uptimerobot.com"
  type    = "CNAME"
  ttl     = 1
}

## docker-node-app

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
    name  = "ingress.hosts[1].host"
    value = cloudflare_record.kube-fairbanks.hostname
  }
  set {
    name  = "ingress.hosts[1].paths[0]"
    value = "/"
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

resource "cloudflare_record" "kube-fairbanks" {
  zone_id = var.cloudflare_zone_id_fairbanks
  name    = "kube"
  proxied = true
  value   = data.kubernetes_service.nginx-ingress-controller.load_balancer_ingress.0.ip
  type    = "A"
  ttl     = 1
}

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

## Tetris

resource "kubernetes_namespace" "tetris" {
  metadata {
    name = "tetris"
  }
}

resource "helm_release" "tetris_pretty-default-backend" {
  name       = "pretty-default-backend"
  repository = "https://h.cfcr.io/fairbanks.io/default"
  chart      = "pretty-default-backend"
  namespace  = "tetris"
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

## F5

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
  set_sensitive {
    name  = "MONGO_URI"
    value = var.f5_mongo_uri
  }
  set {
    name  = "image.tag"
    value = "1.0.0"
  }
}

resource "helm_release" "f5-web" {
  repository = "https://jonfairbanks.github.io/helm-charts"
  chart      = "f5-web"
  name       = "f5-web"
  namespace  = "f5oclock"
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
    value = "1.0.0"
  }
}

resource "cloudflare_record" "f5-web" {
  zone_id = var.cloudflare_zone_id_fairbanks
  name    = "f5"
  proxied = true
  value   = data.kubernetes_service.nginx-ingress-controller.load_balancer_ingress.0.ip
  type    = "A"
  ttl     = 1
}

## Halbert

resource "kubernetes_namespace" "halbert" {
  metadata {
    name = "halbert"
  }
}

resource "helm_release" "halbert" {
  repository = "https://jonfairbanks.github.io/helm-charts"
  chart      = "halbert"
  name       = "halbert"
  namespace  = "halbert"
  set_sensitive {
    name  = "HUBOT_SLACK_TOKEN"
    value = var.hubot_slack_token
  }
  set {
    name  = "image.tag"
    value = "2.0.0"
  }
}

## JSON Formatter

resource "kubernetes_namespace" "json-formatter" {
  metadata {
    name = "json-formatter"
  }
}

resource "helm_release" "json-formatter" {
  repository = "https://jonfairbanks.github.io/helm-charts"
  chart      = "json-formatter"
  name       = "json-formatter"
  namespace  = "json-formatter"
  set {
    name  = "ingress.enabled"
    value = "true"
  }
  set {
    name  = "ingress.hosts[0].host"
    value = cloudflare_record.json-formatter.hostname
  }
  set {
    name  = "ingress.hosts[0].paths[0]"
    value = "/"
  }
  set {
    name  = "image.tag"
    value = "0.1.0"
  }
}

resource "cloudflare_record" "json-formatter" {
  zone_id = var.cloudflare_zone_id_fairbanks
  name    = "json"
  proxied = true
  value   = data.kubernetes_service.nginx-ingress-controller.load_balancer_ingress.0.ip
  type    = "A"
  ttl     = 1
}

## Markdown Editor

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