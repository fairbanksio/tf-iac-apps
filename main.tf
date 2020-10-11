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
    cloudflare = "cloudflare"
  }
}