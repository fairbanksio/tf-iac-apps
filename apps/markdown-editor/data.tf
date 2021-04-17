data "digitalocean_kubernetes_cluster" "k8s" {
  name = var.do_cluster_name
}

data "kubernetes_service" "nginx-ingress-controller" {
  metadata {
    name = "kube-system-nginx-ingress-controller"
  }
}

## IMPORTANT! NEEED TO ADD DATA HERE TO GET THE KUBE CLUSTER AS A REFERENCE
## POSSIBLY GRAB THE OUTPUT FROM THE REMOTE STATE OF tf-iac-cluster