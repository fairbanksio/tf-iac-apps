terraform {
  backend "remote" {
    organization = "Fairbanks-io"

    workspaces {
      name = "tf-iac-apps"
    }
  }
}

module "docker-node-app" {
  source = "./apps/docker-node-app"
  name = "kube.fairbanks"
  providers = {
    kubernetes = kubernetes
    cloudflare = cloudflare
  }
  cloudflare_zone_id           = "${var.cloudflare_zone_id}"
  cloudflare_zone_id_fairbanks = "${var.cloudflare_zone_id_fairbanks}"
}