## Tiles

resource "kubernetes_namespace" "rcvr" {
  metadata {
    name = "rcvr"
  }
}

resource "helm_release" "tiles-api_pretty-default-backend" {
  name       = "pretty-default-backend"
  repository = "https://h.cfcr.io/bsord/charts"
  chart      = "pretty-default-backend"
  namespace  = "rcvr"
  version = "0.4.0"
  set {
    name  = "autoscaling.enabled"
    value = true
  }
  set {
    name  = "autoscaling.minReplicas"
    value = 2
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

resource "helm_release" "rcvr-web" {
  repository = "https://h.cfcr.io/bsord/charts"
  chart      = "rcvr-web"
  name       = "rcvr-web"
  namespace  = "rcvr"
  version = "0.10.0"
  set {
    name  = "autoscaling.enabled"
    value = true
  }
  set {
    name  = "autoscaling.minReplicas"
    value = 2
  }
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
  value   = data.kubernetes_service.nginx-ingress-controller.status.0.load_balancer.0.ingress.0.ip
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
    name  = "master.persistence.size"
    value = "2Gi"
  }
  set {
    name  = "slave.persistence.size"
    value = "2Gi"
  }
  set {
    name  = "cluster.slaveCount"
    value = 1
  }
  set {
    name  = "metrics.enabled"
    value = true
  }
}

resource "helm_release" "rcvr-db" {
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mariadb"
  name       = "rcvr-db"
  namespace  = "rcvr"
  set {
    name  = "auth.username"
    value = "rcvr"
  }
  set_sensitive {
    name  = "auth.password"
    value = var.rcvr_dbpassword
  }
  set {
    name  = "auth.database"
    value = "rcvr"
  }
  set_sensitive {
    name  = "architecture"
    value = "replication"
  }
  set {
    name  = "primary.pdb.enabled"
    value = true
  }
  set {
    name  = "primary.pdb.minAvailable"
    value = 1
  }
  set {
    name  = "secondary.pdb.enabled"
    value = true
  }
  set {
    name  = "secondary.pdb.minAvailable"
    value = 1
  }
  set {
    name  = "primary.persistence.size"
    value = "5Gi"
  }
  set {
    name  = "secondary.persistence.size"
    value = "5Gi"
  }
  set {
    name  = "secondary.replicaCount"
    value = 1
  }
  set {
    name  = "metrics.enabled"
    value = true
  }
}

resource "helm_release" "rcvr-relay" {
  repository = "https://bsord.github.io/helm-charts"
  chart      = "postfix"
  name       = "rcvr-relay"
  namespace  = "rcvr"
  version = "0.3.0"
  set {
    name  = "autoscaling.enabled"
    value = true
  }
  set {
    name  = "autoscaling.minReplicas"
    value = 2
  }
  set {
    name  = "allowedSenderDomains"
    value = "bsord.dev"
  }
  set {
    name  = "dkimKey"
    value = var.rcvr_dkim_key
  }
}

resource "cloudflare_record" "rcvr-dkim" {
  zone_id = var.cloudflare_zone_id
  name    = "mail._domainkey"
  proxied = false
  value   = "v=DKIM1;k=rsa;p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDHRdd8tndhQmPuu9uUhPP91koO3yUIAtmwFO8yjt7zg8+CnNLTFL2v39teN/Dg26MfxLlDIXAKuqvKchA9pvwtDpNgc5Hh44aRJeQMzGqSzZkqpFYDSZ1AGqQ6MIeu1wE2ksKKY0i5d1xDTEWyyD4dAhovbhLXyZSgqILlCSbvMwIDAQAB"
  type    = "TXT"
  ttl     = 1
}

resource "helm_release" "rcvr-api" {
  repository = "https://h.cfcr.io/bsord/charts"
  chart      = "rcvr-api"
  name       = "rcvr-api"
  namespace  = "rcvr"
  version = "0.17.0"
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
    value = 2
  }
  set {
    name  = "resources.limits.cpu"
    value = "200m"
  }
  set {
    name  = "resources.limits.memory"
    value = "200Mi"
  }
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
  value   = data.kubernetes_service.nginx-ingress-controller.status.0.load_balancer.0.ingress.0.ip
  type    = "A"
  ttl     = 1
}

resource "helm_release" "rcvr-smtp" {
  repository = "https://h.cfcr.io/bsord/charts"
  chart      = "rcvr-smtp"
  name       = "rcvr-smtp"
  namespace  = "rcvr"
  version = "0.5.0"
  set {
    name  = "autoscaling.enabled"
    value = true
  }
  set {
    name  = "autoscaling.minReplicas"
    value = 2
  }
  set {
    name  = "dbHost"
    value = "rcvr-db-mariadb-primary"
  }
  
}

resource "cloudflare_record" "rcvr-smtp" {
  zone_id = var.cloudflare_zone_id
  name    = "rcvr-in"
  proxied = false
  value   = data.kubernetes_service.nginx-ingress-controller.status.0.load_balancer.0.ingress.0.ip
  type    = "A"
  ttl     = 1
}

resource "helm_release" "rcvr-dmarc" {
  repository = "https://h.cfcr.io/bsord/charts"
  chart      = "rcvr-dmarc"
  name       = "rcvr-dmarc"
  version = "0.3.0"
  namespace  = "rcvr"
  set {
    name  = "autoscaling.enabled"
    value = true
  }
  set {
    name  = "autoscaling.minReplicas"
    value = 2
  }
}