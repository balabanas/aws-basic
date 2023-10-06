terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }

    tls = {
      source = "hashicorp/tls"
    }

    acme = {
      source  = "vancluever/acme"
      # version = "= 2.17"
    }

  }
}

provider "aws" {
  region = var.region
}
provider "acme" {
  server_url = var.server_url
}
provider "tls" {}
