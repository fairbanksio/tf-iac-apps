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
  version = "1.1.0"
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
    name  = "ingress.enabled"
    value = "true"
  }
  set {
    name  = "ingress.hosts[0].host"
    value = "json.fairbanks.dev"
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

