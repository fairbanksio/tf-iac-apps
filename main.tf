terraform {
  backend "remote" {
    organization = "Fairbanks-io"

    workspaces {
      name = "tf-iac-apps"
    }
  }
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
