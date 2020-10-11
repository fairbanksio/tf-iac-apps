terraform {
  backend "remote" {
    organization = "Fairbanks-io"

    workspaces {
      name = "tf-iac-apps"
    }
  }
}

locals {
  providers = {
    cloudflare = cloudflare
  }
}

module "kube-fairbanks-dev" {
  source = "./apps/docker-node-app"
  providers = "${local.providers}"
  cloudflare_zone_id = "${var.cloudflare_zone_id_fairbanks}"
  do_cluster_name    = "${var.do_cluster_name}"
}

/* module "kube-bsord-dev" {
  source    = "./apps/docker-node-app"
  providers = "${local.providers}"
  cloudflare_zone_id = "${var.cloudflare_zone_id}"
  do_cluster_name    = "${var.do_cluster_name}"
} */