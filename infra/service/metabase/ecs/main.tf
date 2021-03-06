
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

resource "aws_ecs_service" "service" {
  name            = module.naming.name
  cluster         = local.cluster_name
  task_definition = aws_ecs_task_definition.definition.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  load_balancer {
    target_group_arn = local.target_group_arn
    container_name   = module.naming.name
    container_port   = 3000
  }

  network_configuration {
    subnets          = local.subnet_ids
    security_groups  = [aws_security_group.security_group.id]
    assign_public_ip = false
  }
}