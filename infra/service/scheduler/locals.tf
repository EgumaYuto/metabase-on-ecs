locals {
  role = "scheduler"

  vpc_id    = data.terraform_remote_state.vpc.outputs.id
  subnet_id = data.terraform_remote_state.private_subnet.outputs.ids[0]
  rds = {
    writer   = data.terraform_remote_state.rds.outputs.endpoint.writer
    port     = data.terraform_remote_state.rds.outputs.endpoint.port
    password = data.aws_ssm_parameter.password.value
  }
}