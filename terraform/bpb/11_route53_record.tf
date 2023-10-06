resource "aws_route53_record" "www" {
  zone_id = "Z029401313M03D9ZXAFJ9"  # copy-paste from actual zone, created manually
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = "dualstack.${aws_lb.production.dns_name}" //dualstack.
    zone_id                = aws_lb.production.zone_id
    evaluate_target_health = true
  }
}