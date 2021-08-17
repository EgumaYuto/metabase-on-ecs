locals {
  role       = "metabase"
  vpc_id     = data.terraform_remote_state.vpc.outputs.id
  subnet_ids = data.terraform_remote_state.public_subnet.outputs.ids
}