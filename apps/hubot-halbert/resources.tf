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
    name  = "slack.token"
    value = var.hubot_slack_token
  }
  set {
    name  = "image.tag"
    value = "2.0.0"
  }
}