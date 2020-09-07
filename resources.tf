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
    name  = "mariadb.enabled"
    value = "true"
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
    name  = "internalDatabase.enabled"
    value = "false"
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
    value = "#112233"
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
    value = "404"
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
  set {
    name  = "MONGO_URI"
    value = var.f5_mongo_uri
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
  set {
    name  = "MONGO_URI"
    value = var.f5_mongo_uri
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
  set {
    name  = "HUBOT_SLACK_TOKEN"
    value = var.hubot_slack_token
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
}

resource "cloudflare_record" "markdown-editor" {
  zone_id = var.cloudflare_zone_id_fairbanks
  name    = "md"
  proxied = true
  value   = data.kubernetes_service.nginx-ingress-controller.load_balancer_ingress.0.ip
  type    = "A"
  ttl     = 1
}