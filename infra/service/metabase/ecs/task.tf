data "aws_iam_policy_document" "task_assume_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "task_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameters",
      "kms:Decrypt"
    ]
    resources = ["*"] // TODO 絞る
  }
}

resource "aws_iam_role" "execution_role" {
  name               = "${module.naming.name}-execution-role"
  assume_role_policy = data.aws_iam_policy_document.task_assume_policy.json
}

resource "aws_iam_role_policy_attachment" "execution_policy_attachment" {
  role       = aws_iam_role.execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "execution_task_policy_attachment" {
  role       = aws_iam_role.execution_role.name
  policy_arn = aws_iam_policy.task_policy.arn
}

resource "aws_iam_role" "task_role" {
  name               = "${module.naming.name}-task-role"
  assume_role_policy = data.aws_iam_policy_document.task_assume_policy.json
}

resource "aws_iam_policy" "task_policy" {
  policy = data.aws_iam_policy_document.task_policy.json
}

resource "aws_iam_role_policy_attachment" "task_policy_attachment" {
  role       = aws_iam_role.task_role.name
  policy_arn = aws_iam_policy.task_policy.arn
}

resource "aws_ecs_task_definition" "definition" {
  family       = module.naming.name
  network_mode = "awsvpc"

  execution_role_arn = aws_iam_role.execution_role.arn
  task_role_arn      = aws_iam_role.task_role.arn

  cpu                      = "512"
  memory                   = "4096"
  requires_compatibilities = ["FARGATE"]

  container_definitions = <<EOF
[
  {
    "image": "metabase/metabase:latest",
    "cpu": 512,
    "memory": 4096,
    "networkMode": "awsvpc",
    "essential": true,
    "name": "${module.naming.name}",
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.log_group.name}",
        "awslogs-region": "ap-northeast-1",
        "awslogs-stream-prefix": "ecs"
      }
    },
    "environment": [
      {
        "name": "MB_JETTY_HOST",
        "value": "0.0.0.0"
      },
      {
        "name": "MB_DB_DBNAME",
        "value": "metabase"
      },
      {
        "name": "MB_DB_HOST",
        "value": "${local.rds_endpoint}"
      },
      {
        "name": "MB_DB_PORT",
        "value": "5432"
      },
      {
        "name": "MB_DB_TYPE",
        "value": "postgres"
      },
      {
        "name": "MB_DB_USER",
        "value": "metabase"
      }
    ],
    "secrets": [
      {
        "name": "MB_DB_PASS",
        "valueFrom": "${local.rds_password_arn}"
      }
    ],
    "portMappings": [
      {
        "containerPort": 3000,
        "protocol": "tcp",
        "containerPort": 3000
      }
    ]
  }
]
EOF
}
