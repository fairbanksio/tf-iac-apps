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
  version = "1.1.0"
  set {
    name  = "autoscaling.enabled"
    value = true
  }
  set {
    name  = "ingress.enabled"
    value = "true"
  }
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
    name  = "ingress.hosts[0].host"
    value = "fairbanks.dev"
  }
  set {
    name  = "ingress.hosts[0].paths[0]"
    value = "/"
  }
}
