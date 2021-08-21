output "zone" {
  value = {
    id   = aws_route53_zone.public.zone_id
    name = aws_route53_zone.public.name
  }
}