locals {
  role       = "metabase-actions-user"
  account_id = data.aws_caller_identity.identity.account_id
}