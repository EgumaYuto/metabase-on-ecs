locals {
  role       = "metabase"
  vpc_id     = data.terraform_remote_state.vpc.outputs.id
  subnet_ids = data.terraform_remote_state.public_subnet.outputs.ids
  public_zone = {
    id   = data.terraform_remote_state.public_dns.outputs.zone.id
    name = data.terraform_remote_state.public_dns.outputs.zone.name
  }
  certificate_arn = data.terraform_remote_state.public_dns.outputs.acm_apn1.arn
}