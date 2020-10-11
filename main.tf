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
  providers = {
    cloudflare = cloudflare
  }
  cloudflare_zone_id           = "${var.cloudflare_zone_id}"
  cloudflare_zone_id_fairbanks = "${var.cloudflare_zone_id_fairbanks}"
  do_cluster_name              = "${var.do_cluster_name}"
}