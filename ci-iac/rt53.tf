resource "aws_route53_record" "fofun_record" {
  provider = aws.ozi
  zone_id  = "Z051803612ODKK7ELB6J8"
  name     = "fofun.iplatinum.pro"
  type     = "A"

  alias {
    name                   = aws_lb.fofun_elb.dns_name
    zone_id                = aws_lb.fofun_elb.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "cicd_record" {
  provider = aws.ozi
  zone_id  = "Z051803612ODKK7ELB6J8"
  name     = "cicd.iplatinum.pro"
  type     = "A"

  alias {
    name                   = aws_lb.fofun_elb.dns_name
    zone_id                = aws_lb.fofun_elb.zone_id
    evaluate_target_health = false
  }
}