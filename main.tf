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

module "docker-node-app" {
  source = "./apps/docker-node-app"
  providers = {
    cloudflare = cloudflare
  }
  cloudflare_zone_id = "${var.cloudflare_zone_id_fairbanks}"
  do_cluster_name    = "${var.do_cluster_name}"
}

/* module "docker-node-app-bsord" {
  source    = "./apps/docker-node-app"
  providers = {
    cloudflare = cloudflare
  }
  cloudflare_zone_id = "${var.cloudflare_zone_id}"
  do_cluster_name    = "${var.do_cluster_name}"
} */

module "f5oclock" {
  source = "./apps/f5oclock"
  providers = {
    cloudflare = cloudflare
  }
  cloudflare_zone_id = "${var.cloudflare_zone_id_fairbanks}"
  do_cluster_name    = "${var.do_cluster_name}"
  f5_mongo_uri       = "${var.f5_mongo_uri}"
}