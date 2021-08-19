locals {
  role = "metabase-db"
  database = {
    name = "metabase"
    master = {
      username = "metabase"
      password = "SuperSecr3t" // TODO ssm から引っ張ってくるようにする
    }
  }
  vpc_id     = data.terraform_remote_state.vpc.outputs.id
  subnet_ids = data.terraform_remote_state.private_subnet.outputs.ids
}