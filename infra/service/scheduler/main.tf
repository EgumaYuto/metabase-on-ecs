terraform {
  backend "s3" {
  }
}

provider "aws" {
  region = var.default_region
}

module "naming" {
  source = "../../_module/naming"
  role   = local.role
}

resource "aws_s3_bucket" "source" {
  bucket = "${module.naming.name}-source"
}