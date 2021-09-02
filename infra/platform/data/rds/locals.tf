locals {
  role = "metabase-db"
  database = {
    name = "metabase"
    port = 5432
    master = {
      username = "metabase"
      password = data.aws_ssm_parameter.password.value
    }
  }
  vpc_id     = data.terraform_remote_state.vpc.outputs.id
  subnet_ids = data.terraform_remote_state.private_subnet.outputs.ids
  private_zone = {
    id   = data.terraform_remote_state.private_dns.outputs.zone.id
    name = data.terraform_remote_state.private_dns.outputs.zone.name
  }
}