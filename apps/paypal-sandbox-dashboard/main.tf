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
    name  = "autoscaling.maxReplicas"
    value = 3
  }
  set {
    name  = "limits.cpu"
    value = "200m"
  }
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
    value = "sandbox.fairbanks.dev"
  }
  set {
    name  = "ingress.hosts[0].paths[0]"
    value = "/"
  }
}

