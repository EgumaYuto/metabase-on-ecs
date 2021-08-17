output "target_group" {
  value = {
    arn  = aws_alb_target_group.target_group.arn
    name = aws_alb_target_group.target_group.name
  }
}

output "listener" {
  value = {
    arn = aws_alb_listener.alb.arn
  }
}