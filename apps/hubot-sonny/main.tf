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
    value = var.hubot_slack_token
  }
}