terraform {
  backend "s3" {
  }
}

provider "aws" {
  region = var.default_region
}

module "password" {
  source   = "../_module/naming"
  name     = "rds"
  resource = "password"
}

resource "aws_ssm_parameter" "password" {
  name  = module.password.name
  type  = "SecureString"
  value = random_string.password.result

  lifecycle {
    ignore_changes = [value]
  }
}

resource "random_string" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

