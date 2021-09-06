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

resource "aws_glue_catalog_database" "database" {
  name = module.naming.name
}

resource "aws_security_group" "security_group" {
  name        = module.naming.name
  description = module.naming.name
  vpc_id      = local.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_glue_connection" "connection" {
  name = module.naming.name

  connection_properties = {
    JDBC_CONNECTION_URL = "jdbc:postgresql://${local.rds.writer}:${local.rds.port}/metabase"
    PASSWORD            = local.rds.password
    USERNAME            = "metabase"
  }

  physical_connection_requirements {
    availability_zone      = var.default_availability_zones[0] // TODO たまたま揃っているだけなので、明示的に揃える
    subnet_id              = local.subnet_id
    security_group_id_list = [aws_security_group.security_group.id]
  }
}