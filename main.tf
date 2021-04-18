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

## JSON Formatter

module "json-formatter" {
  source             = "./apps/json-formatter"
  cloudflare_zone_id = var.cloudflare_zone_id_fairbanks
  do_cluster_name    = var.do_cluster_name
}

## Markdown Editor

module "markdown-editor" {
  source             = "./apps/markdown-editor"
  cloudflare_zone_id = var.cloudflare_zone_id_fairbanks
  do_cluster_name    = var.do_cluster_name
}

## Nextcloud

module "nextcloud" {
  source                     = "./apps/nextcloud"
  cloudflare_zone_id         = var.cloudflare_zone_id_fairbanks
  do_cluster_name            = var.do_cluster_name
  nextcloud_mariadb_host     = var.nextcloud_mariadb_host
  nextcloud_mariadb_user     = var.nextcloud_mariadb_user
  nextcloud_mariadb_password = var.nextcloud_mariadb_password
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

## Status Page(s)

module "statuspage-jonfairbanks" {
  source             = "./apps/statuspage-jonfairbanks"
  cloudflare_zone_id = var.cloudflare_zone_id_fairbanks
}

module "statuspage-bsord" {
  source             = "./apps/statuspage-bsord"
  cloudflare_zone_id = var.cloudflare_zone_id_bsord
}

## Mealie

#module "mealie" {
#  source             = "./apps/mealie"
#  cloudflare_zone_id = var.cloudflare_zone_id_fairbanks
#  do_cluster_name    = var.do_cluster_name
#}