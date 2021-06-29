resource "aws_acm_certificate" "fofun_ssl" {
  domain_name               = "fofun.iplatinum.pro"
  subject_alternative_names = ["cicd.iplatinum.pro"]
  validation_method         = "DNS"
  tags                      = { Name = "fofun.iplatinum.pro" }
  lifecycle { create_before_destroy = true }
}

resource "aws_acm_certificate_validation" "fofun_cert_validation" {
  timeouts {
    create = "5m"
  }
  certificate_arn         = aws_acm_certificate.fofun_ssl.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_validation : record.fqdn]
}


resource "aws_route53_record" "acm_validation" {
  provider = aws.ozi
  for_each = {
    for dvo in aws_acm_certificate.fofun_ssl.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = "Z051803612ODKK7ELB6J8"
}