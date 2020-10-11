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
    cloudflare_zone_id = var.cloudflare_zone_id
    cloudflare_zone_id_fairbanks = var.cloudflare_zone_id_fairbanks
  }
}

module "docker-node-app" {
  source = "./apps/docker-node-app"
  context = local.default
  providers = {
    cloudflare = "cloudflare"
  }
}