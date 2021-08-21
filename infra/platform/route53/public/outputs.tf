output "zone" {
  value = {
    id   = aws_route53_zone.public.zone_id
    name = aws_route53_zone.public.name
  }
}

output "acm_apn1" {
  value = {
    arn = aws_acm_certificate.apn1.arn
  }
}