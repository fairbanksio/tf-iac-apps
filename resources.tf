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
}

resource "cloudflare_record" "kube" {
  zone_id = var.cloudflare_zone_id
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
}

resource "cloudflare_record" "tetris" {
  zone_id = var.cloudflare_zone_id
  name    = "tetris"
  proxied = true
  value   = data.kubernetes_service.nginx-ingress-controller.load_balancer_ingress.0.ip
  type    = "A"
  ttl     = 1
}


