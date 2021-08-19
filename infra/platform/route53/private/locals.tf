locals {
  domain = "${terraform.workspace}.metabase.internal"
  vpc_id = data.terraform_remote_state.vpc.outputs.id
}