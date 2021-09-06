output "endpoint" {
  value = {
    writer = "${aws_route53_record.writer.name}.${local.private_zone.name}"
    reader = "${aws_route53_record.reader.name}.${local.private_zone.name}"
    port   = local.database.port
  }
}