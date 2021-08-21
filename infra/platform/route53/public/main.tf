terraform {
  backend "s3" {
  }
}

provider "aws" {
  region = var.default_region
}

resource "aws_route53_zone" "public" {
  name = local.name
}

resource "aws_route53_record" "ns" {
  zone_id = data.aws_route53_zone.root.zone_id
  name    = local.name
  type    = "NS"
  ttl     = 30
  records = aws_route53_zone.public.name_servers
}