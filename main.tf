terraform {
  backend "remote" {
    organization = "Fairbanks-io"

    workspaces {
      name = "tf-iac-apps"
    }
  }
}

locals {
  default = {
    cloudflare_zone_id                          = "${var.cloudflare_zone_id}"
    cloudflare_zone_id_fairbanks                = "${var.cloudflare_zone_id_fairbanks}"
    kubernetes_service.nginx-ingress-controller = "${data.data.kubernetes_service.nginx-ingress-controller}"
  }
}

module "docker-node-app" {
  source = "./apps/docker-node-app"
  providers = {
    cloudflare = cloudflare
  }
  cloudflare_zone_id           = "${var.cloudflare_zone_id}"
  cloudflare_zone_id_fairbanks = "${var.cloudflare_zone_id_fairbanks}"
  kubernetes_service.nginx-ingress-controller = "${data.data.kubernetes_service.nginx-ingress-controller}"
}