resource "aws_route53_record" "record" {
  zone_id = local.public_zone.id
  name    = "metabase.${local.public_zone.name}"
  type    = "A"

  alias {
    name                   = aws_alb.alb.dns_name
    zone_id                = aws_alb.alb.zone_id
    evaluate_target_health = false
  }
}