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
  version = "1.2.0"
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
    value = "md.fairbanks.dev"
  }
  set {
    name  = "ingress.hosts[0].paths[0]"
    value = "/"
  }
  set {
    name  = "image.tag"
    value = "0.1.2"
  }
}

