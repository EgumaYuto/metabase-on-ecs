resource "aws_s3_bucket" "source" {
  bucket        = "${module.naming.name}-source"
  acl           = "private"
  force_destroy = true
}