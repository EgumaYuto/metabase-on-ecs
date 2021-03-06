data "aws_iam_policy_document" "assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
    effect = "Allow"
  }
}

resource "aws_iam_role" "role" {
  name               = "${module.naming.name}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_policy.json
}

resource "aws_iam_role_policy_attachment" "attachment" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess" // TODO 適宜絞り込む
}