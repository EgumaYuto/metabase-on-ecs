output "password" {
  value = {
    name = aws_ssm_parameter.password.name
  }
}