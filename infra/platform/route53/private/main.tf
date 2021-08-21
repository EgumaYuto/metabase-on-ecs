terraform {
  backend "s3" {
  }
}

provider "aws" {
  region = var.default_region
}

resource "aws_route53_zone" "private" {
  name = local.domain

  vpc {
    vpc_id = local.vpc_id
  }
}