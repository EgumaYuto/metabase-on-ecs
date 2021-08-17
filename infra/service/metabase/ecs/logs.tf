resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/${terraform.workspace}/ecs/metabase"
  retention_in_days = 7
}