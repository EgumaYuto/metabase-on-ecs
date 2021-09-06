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

data "terraform_remote_state" "rds" {
  backend = "s3"

  config = {
    bucket = var.state_bucket
    key    = "env:/${terraform.workspace}/state/platform/data/rds.tfstate"
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

data "aws_ssm_parameter" "password" {
  name = data.terraform_remote_state.rds_parameters.outputs.password.name
}