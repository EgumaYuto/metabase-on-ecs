locals {
  role             = "metabase"
  vpc_id           = data.terraform_remote_state.vpc.outputs.id
  subnet_ids       = data.terraform_remote_state.private_subnet.outputs.ids
  cluster_name     = data.terraform_remote_state.main_cluster.outputs.name
  target_group_arn = data.terraform_remote_state.elb.outputs.target_group.arn
  rds_endpoint     = data.terraform_remote_state.rds.outputs.endpoint.writer
}