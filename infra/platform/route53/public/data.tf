data "aws_route53_zone" "root" {
  zone_id = local.root_zone_id
}