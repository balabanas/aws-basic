
resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "registration" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address = var.email
}

resource "acme_certificate" "certificate" {
  account_key_pem = acme_registration.registration.account_key_pem
  common_name = var.domain_name
  subject_alternative_names = var.dns_alt_names

  dns_challenge {
    provider = "route53"
  }
}

resource "aws_acm_certificate" "cert" {
  private_key        =  acme_certificate.certificate.private_key_pem
  certificate_body   =  acme_certificate.certificate.certificate_pem
  certificate_chain  =  acme_certificate.certificate.issuer_pem
  depends_on         =  [
    acme_certificate.certificate,
    tls_private_key.private_key,
    acme_registration.registration
  ]
}

output "cert_arn" {
  value = aws_acm_certificate.cert.arn
}


#resource "aws_route53_delegation_set" "main" {
#  reference_name = "DynDNS"
#}
#
#resource "aws_route53_zone" "primary" {
#  name              = "kanavino.ru"
#  delegation_set_id = aws_route53_delegation_set.main.id
#}