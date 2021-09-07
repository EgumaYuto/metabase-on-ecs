data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = var.state_bucket
    key    = "env:/${terraform.workspace}/state/platform/network/vpc.tfstate"
    region = var.default_region
  }
}

data "terraform_remote_state" "private_subnet" {
  backend = "s3"

  config = {
    bucket = var.state_bucket
    key    = "env:/${terraform.workspace}/state/platform/network/subnet/private.tfstate"
    region = var.default_region
  }
}

data "terraform_remote_state" "main_cluster" {
  backend = "s3"

  config = {
    bucket = var.state_bucket
    key    = "env:/${terraform.workspace}/state/platform/ecs-cluster.tfstate"
    region = var.default_region
  }
}

data "terraform_remote_state" "rds" {
  backend = "s3"

  config = {
    bucket = var.state_bucket
    key    = "env:/${terraform.workspace}/state/platform/data/rds.tfstate"
    region = var.default_region
  }
}

data "terraform_remote_state" "elb" {
  backend = "s3"

  config = {
    bucket = var.state_bucket
    key    = "env:/${terraform.workspace}/state/service/metabase/elb.tfstate"
    region = var.default_region
  }
}

data "terraform_remote_state" "rds_parameters" {
  backend = "s3"

  config = {
    bucket = var.state_bucket
    key    = "env:/${terraform.workspace}/state/platform/parameters/rds.tfstate"
    region = var.default_region
  }
}