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
    security_group_id_list = ["sg-0c2f123c3a4c13503"] // TODO デフォルトなので、自前ちゃんと自前で準備する
  }
}