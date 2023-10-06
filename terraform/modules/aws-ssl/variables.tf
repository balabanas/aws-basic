# ssl
variable "server_url" {
  type = string
#  default = "https://acme-staging-v02.api.letsencrypt.org/directory"  // https://acme-v02.api.letsencrypt.org/directory
}

variable "domain_name" {
  type = string
}

variable "email" {
  type = string
#  default = "asbbnv@gmail.com"
}

variable "dns_alt_names" {
  type = list(string)
  default = []
}

variable "s3_bucket_name" {
  type = string
#  default = "asbbnv-ssl"
}

