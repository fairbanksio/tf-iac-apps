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

module "homepage-bsord" {
  source = "./apps/homepage-bsord"
  providers = {
    cloudflare = cloudflare
  }
  cloudflare_zone_id = "${var.cloudflare_zone_id}"
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

module "hubot-halbert" {
  source = "./apps/hubot-halbert"
  hubot_slack_token  = "${var.hubot_slack_token}"
}

module "hubot-sonny" {
  source = "./apps/hubot-sonny"
  hubot_slack_token  = "${var.hubot_slack_token_sonny}"
}

module "json-formatter" {
  source = "./apps/json-formatter"
  providers = {
    cloudflare = cloudflare
  }
  cloudflare_zone_id = "${var.cloudflare_zone_id_fairbanks}"
  do_cluster_name    = "${var.do_cluster_name}"
}

module "markdown-editor" {
  source = "./apps/markdown-editor"
  providers = {
    cloudflare = cloudflare
  }
  cloudflare_zone_id = "${var.cloudflare_zone_id_fairbanks}"
  do_cluster_name    = "${var.do_cluster_name}"
}

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
  cloudflare_zone_id = "${var.cloudflare_zone_id}"
}

module "tetris" {
  source = "./apps/statuspage-jonfairbanks"
  providers = {
    cloudflare = cloudflare
  }
  cloudflare_zone_id = "${var.cloudflare_zone_id}"
  do_cluster_name    = "${var.do_cluster_name}"
}
