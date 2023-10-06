resource "aws_s3_object" "private_key" {
  bucket = var.s3_bucket_name
  key = "${var.domain_name}.key"
  content = acme_certificate.certificate.private_key_pem
}

resource "aws_s3_object" "certificate" {
  bucket = var.s3_bucket_name
  key = "${var.domain_name}.crt"
  content = acme_certificate.certificate.certificate_pem
}