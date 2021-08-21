resource "aws_route53_record" "reader" {
  zone_id = local.private_zone.id
  name    = "reader"
  type    = "CNAME"
  records = [aws_rds_cluster.postgresql.reader_endpoint]
  ttl     = 180
}

resource "aws_route53_record" "writer" {
  zone_id = local.private_zone.id
  name    = "writer"
  type    = "CNAME"
  records = [aws_rds_cluster.postgresql.endpoint]
  ttl     = 180
}