data "kubernetes_service" "nginx-ingress-controller" {
  metadata {
    name = "ingress-nginx-ingress-controller"
  }
  ## THIS DEPENDS MAY NOT BE NEEDED AFTER TF STATE SPLIT.
  depends_on = [helm_release.ingress]
  
}

## IMPORTANT! NEEED TO ADD DATA HERE TO GET THE KUBE CLUSTER AS A REFERENCE
## POSSIBLY GRAB THE OUTPUT FROM THE REMOTE STATE OF tf-iac-cluster