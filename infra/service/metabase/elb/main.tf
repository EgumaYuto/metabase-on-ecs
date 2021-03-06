terraform {
  backend "s3" {
  }
}

provider "aws" {
  region = var.default_region
}

module "naming" {
  source = "../../../_module/naming"
  role   = local.role
}

resource "aws_alb" "alb" {
  name            = module.naming.name
  security_groups = [aws_security_group.security_group.id]
  subnets         = local.subnet_ids
  internal        = false
}

resource "aws_alb_target_group" "target_group" {
  name        = module.naming.name
  vpc_id      = local.vpc_id
  protocol    = "HTTP"
  port        = 3000
  target_type = "ip"

  health_check {
    enabled  = true
    interval = 60
    timeout  = 30
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = local.certificate_arn

  default_action {
    target_group_arn = aws_alb_target_group.target_group.arn
    type             = "forward"
  }
}