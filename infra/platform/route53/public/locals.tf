locals {
  root_zone_id = "Z33ACVXF27ZA5Q"
  name         = "${terraform.workspace}.${data.aws_route53_zone.root.name}"
}