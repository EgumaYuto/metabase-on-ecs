output "zone" {
  value = {
    id   = aws_route53_zone.private.zone_id
    name = aws_route53_zone.private.name
  }
}