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

resource "aws_security_group" "redshift" {
  name        = "redshift"
  vpc_id      = local.vpc_id
  description = "redshift cluster"

  ingress {
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_redshift_cluster" "cluster" {
  cluster_identifier        = "${module.naming.name}-cluster"
  database_name             = local.database.name
  master_username           = local.database.master.username
  master_password           = local.database.master.password
  node_type                 = "dc2.large"
  cluster_type              = "multi-node"
  number_of_nodes           = 2
  publicly_accessible       = false
  cluster_subnet_group_name = aws_redshift_subnet_group.subnet_group.id
  vpc_security_group_ids    = [aws_security_group.redshift.id]
  skip_final_snapshot       = true
}

resource "aws_redshift_subnet_group" "subnet_group" {
  name       = module.naming.name
  subnet_ids = local.subnet_ids
}