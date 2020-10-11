terraform {
  backend "remote" {
    organization = "Fairbanks-io"

    workspaces {
      name = "tf-iac-apps"
    }
  }
}

## docker-node-app

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

## F5 O'Clock

module "f5oclock" {
  source = "./apps/f5oclock"
  providers = {
    cloudflare = cloudflare
  }
  cloudflare_zone_id = "${var.cloudflare_zone_id_fairbanks}"
  do_cluster_name    = "${var.do_cluster_name}"
  f5_mongo_uri       = "${var.f5_mongo_uri}"
}

## Home Page(s)

module "homepage-bsord" {
  source = "./apps/homepage-bsord"
  providers = {
    cloudflare = cloudflare
  }
  cloudflare_zone_id = "${var.cloudflare_zone_id_bsord}"
  do_cluster_name    = "${var.do_cluster_name}"
}

module "homepage-jonfairbanks" {
  source = "./apps/homepage-jonfairbanks"
  providers = {
    cloudflare = cloudflare
  }
  cloudflare_zone_id = "${var.cloudflare_zone_id_fairbanks}"
  do_cluster_name    = "${var.do_cluster_name}"
}

## Hubot Instance(s)

module "hubot-halbert" {
  source            = "./apps/hubot-halbert"
  hubot_slack_token = "${var.hubot_slack_token}"
}

module "hubot-sonny" {
  source            = "./apps/hubot-sonny"
  hubot_slack_token = "${var.hubot_slack_token_sonny}"
}

## JSON Formatter

module "json-formatter" {
  source = "./apps/json-formatter"
  providers = {
    cloudflare = cloudflare
  }
  cloudflare_zone_id = "${var.cloudflare_zone_id_fairbanks}"
  do_cluster_name    = "${var.do_cluster_name}"
}

## Markdown Editor

module "markdown-editor" {
  source = "./apps/markdown-editor"
  providers = {
    cloudflare = cloudflare
  }
  cloudflare_zone_id = "${var.cloudflare_zone_id_fairbanks}"
  do_cluster_name    = "${var.do_cluster_name}"
}

## Nextcloud

module "nextcloud" {
  source = "./apps/nextcloud"
  providers = {
    cloudflare = cloudflare
  }
  cloudflare_zone_id         = "${var.cloudflare_zone_id_fairbanks}"
  do_cluster_name            = "${var.do_cluster_name}"
  nextcloud_mariadb_host     = "${var.nextcloud_mariadb_host}"
  nextcloud_mariadb_user     = "${var.nextcloud_mariadb_user}"
  nextcloud_mariadb_password = "${var.nextcloud_mariadb_password}"
}

## PayPal Sandbox Dashboard

module "paypal-sandbox-dashboard" {
  source = "./apps/paypal-sandbox-dashboard"
  providers = {
    cloudflare = cloudflare
  }
  cloudflare_zone_id = "${var.cloudflare_zone_id_fairbanks}"
  do_cluster_name    = "${var.do_cluster_name}"
  ppsandbox_mongouri = "${var.ppsandbox_mongouri}"
}

## Status Page(s)

module "statuspage-jonfairbanks" {
  source = "./apps/statuspage-jonfairbanks"
  providers = {
    cloudflare = cloudflare
  }
  cloudflare_zone_id = "${var.cloudflare_zone_id_fairbanks}"
}

module "statuspage-bsord" {
  source = "./apps/statuspage-bsord"
  providers = {
    cloudflare = cloudflare
  }
  cloudflare_zone_id = "${var.cloudflare_zone_id_bsord}"
}

## Tetris

module "tetris" {
  source = "./apps/tetris"
  providers = {
    cloudflare = cloudflare
  }
  cloudflare_zone_id = "${var.cloudflare_zone_id_bsord}"
  do_cluster_name    = "${var.do_cluster_name}"
}

## Tiles

module "tiles" {
  source = "./apps/tiles"
  providers = {
    cloudflare = cloudflare
  }
  cloudflare_zone_id      = "${var.cloudflare_zone_id_bsord}"
  do_cluster_name         = "${var.do_cluster_name}"
  tiles-api_mongouri      = "${var.tiles-api_mongouri}"
  tiles-api_redishost     = "${var.tiles-api_redishost}"
  tiles-api_redispassword = "${var.tiles-api_redispassword}"
}