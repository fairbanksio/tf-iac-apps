terraform {
  backend "remote" {
    organization = "Fairbanks-io"

    workspaces {
      name = "tf-iac-apps"
    }
  }
}

module "kube-fairbanks-dev" {
  source = "./apps/docker-node-app"
  providers = {
    cloudflare = cloudflare
  }
  cloudflare_zone_id = "${var.cloudflare_zone_id_fairbanks}"
  do_cluster_name    = "${var.do_cluster_name}"
}

module "kube-bsord-dev" {
  source    = "./apps/docker-node-app"
  namespace = "docker-node-app-bsord"
  providers = {
    cloudflare = cloudflare
  }
  cloudflare_zone_id = "${var.cloudflare_zone_id}"
  do_cluster_name    = "${var.do_cluster_name}"
}