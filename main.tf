terraform {
  backend "remote" {
    organization = "Fairbanks-io"

    workspaces {
      name = "tf-iac-apps"
    }
  }
}

## F5 O'Clock

module "f5oclock" {
  source             = "./apps/f5oclock"
  cloudflare_zone_id = var.cloudflare_zone_id_fairbanks
  do_cluster_name    = var.do_cluster_name
  f5_mongo_uri       = var.f5_mongo_uri
}

## Hubot Instance(s)

module "hubot-halbert" {
  source            = "./apps/hubot-halbert"
  hubot_slack_token = var.hubot_slack_token_halbert
}

## PayPal

/* module "paypal-ipn" {
  source = "./apps/paypal-ipn"
  providers = {
    cloudflare = cloudflare
  }
  cloudflare_zone_id = var.cloudflare_zone_id_fairbanks
  do_cluster_name    = var.do_cluster_name
  ppipn_mongouri = var.ppipn_mongouri
} */

module "paypal-sandbox-dashboard" {
  source             = "./apps/paypal-sandbox-dashboard"
  cloudflare_zone_id = var.cloudflare_zone_id_fairbanks
  do_cluster_name    = var.do_cluster_name
  ppsandbox_mongouri = var.ppsandbox_mongouri
}