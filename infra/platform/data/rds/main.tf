terraform {
  backend "s3" {
  }
}

provider "aws" {
  region = var.default_region
}

module "naming" {
  source = "../../../_module/naming"
  role   = local.role
}

resource "aws_security_group" "group" {
  name        = "${module.naming.name}-security-group"
  vpc_id      = local.vpc_id
  description = "rds cluster"

  ingress {
    from_port   = local.database.port
    to_port     = local.database.port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_db_subnet_group" "subnet_group" {
  name       = "${module.naming.name}-subnet-group"
  subnet_ids = local.subnet_ids
  tags = {
    Name = "${module.naming.name}-subnet-group"
  }
}

resource "aws_rds_cluster" "postgresql" {
  cluster_identifier      = "${module.naming.name}-cluster"
  engine                  = "aurora-postgresql"
  engine_version          = "11.9"
  port                    = local.database.port
  availability_zones      = var.default_availability_zones
  database_name           = local.database.name
  master_username         = local.database.master.username
  master_password         = local.database.master.password
  backup_retention_period = 3
  preferred_backup_window = "07:00-09:00"
  vpc_security_group_ids  = [aws_security_group.group.id]
  db_subnet_group_name    = aws_db_subnet_group.subnet_group.name
  skip_final_snapshot     = true
}

resource "aws_rds_cluster_instance" "instance" {
  identifier         = "${module.naming.name}-instance"
  cluster_identifier = aws_rds_cluster.postgresql.cluster_identifier
  instance_class     = "db.r5.large"
  engine             = "aurora-postgresql"
  engine_version     = "11.9"
}