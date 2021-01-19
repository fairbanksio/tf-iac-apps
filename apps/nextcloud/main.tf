/*
resource "kubernetes_namespace" "nextcloud" {
  metadata {
    name = "nextcloud"
  }
}

resource "helm_release" "nextcloud" {
  name       = "nextcloud"
  repository = "https://charts.helm.sh/stable"
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
  zone_id = var.cloudflare_zone_id
  name    = "files"
  proxied = true
  value   = data.kubernetes_service.nginx-ingress-controller.load_balancer_ingress.0.ip
  type    = "A"
  ttl     = 1
}

*/