module "ssl" {
  source = "../modules/aws-ssl"

  providers = {
    acme = acme
  }

  server_url = var.server_url
  email = "asbbnv@gmail.com"
  s3_bucket_name = var.s3_bucket_name
  domain_name = var.domain_name

  # to pass the ACME challenge the A record should exist
  depends_on = [aws_route53_record.www]
}


