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

resource "aws_glue_catalog_table" "table" {
  database_name = aws_glue_catalog_database.database.name
  name          = "${module.naming.name}-source"

  parameters = {
    "classification" = "csv"
  }

  storage_descriptor {
    location      = "s3://${aws_s3_bucket.source.bucket}/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      name                  = module.naming.name
      serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"

      parameters = {
        "separatorChar" = ","
      }
    }

    columns {
      name = "Date"
      type = "date"
    }

    columns {
      name = "Prefecture"
      type = "string"
    }

    columns {
      name = "Newly confirmed cases"
      type = "bigint"
    }
  }
}

resource "aws_security_group" "security_group" {
  name        = module.naming.name
  description = module.naming.name
  vpc_id      = local.vpc_id

  ingress { // TODO ザルすぎるので絞る
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