terraform {
  required_providers {

    aws = {
      source = "hashicorp/aws"
    }

    acme = {
      source = "vancluever/acme"
      # version = "= 2.17"
    }

    tls = {
      source = "hashicorp/tls"
    }

  }
}