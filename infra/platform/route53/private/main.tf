resource "aws_route53_zone" "private" {
  name = local.domain

  vpc {
    vpc_id = local.vpc_id
  }
}