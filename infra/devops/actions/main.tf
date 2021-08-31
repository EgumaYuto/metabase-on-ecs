terraform {
  backend "s3" {
  }
}

provider "aws" {
  region = var.default_region
}

module "naming" {
  source = "../../_module/naming"
  role   = local.role
}

// user
resource "aws_iam_user" "user" {
  name = module.naming.name
  tags = {
    name = module.naming.name
  }
}

data "aws_iam_policy_document" "user_policy_document" {
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole", "sts:TagSession"]
    resources = [aws_iam_role.execution_role.arn]
  }
}

resource "aws_iam_policy" "policy" {
  policy = data.aws_iam_policy_document.user_policy_document.json
}

resource "aws_iam_user_policy_attachment" "policy_attachment" {
  user       = aws_iam_user.user.name
  policy_arn = aws_iam_policy.policy.arn
}


// role
data "aws_iam_policy_document" "execution_role_assume_policy_document" {
  statement {
    actions = ["sts:AssumeRole", "sts:TagSession"]
    principals {
      type        = "AWS"
      identifiers = [local.account_id]
    }
    effect = "Allow"
  }
}

resource "aws_iam_role" "execution_role" {
  name               = "${module.naming.name}-role"
  assume_role_policy = data.aws_iam_policy_document.execution_role_assume_policy_document.json
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  role       = aws_iam_role.execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}