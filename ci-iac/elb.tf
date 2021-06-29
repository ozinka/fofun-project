###############################
#   Public Load Balancer      #
###############################
resource "aws_lb" "fofun_elb" {
  name               = "fofun-elb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.fofun_sn1.id, aws_subnet.fofun_sn2.id]
  security_groups    = [aws_security_group.elb_fofun_sg.id]

  tags = { Name = "fofun-elb" }
}

resource "aws_lb_target_group" "jn_tg" {
  name                 = "jn-tg"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = aws_vpc.fofun_vpc.id
  deregistration_delay = 5

  health_check {
    port                = 80
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 3
    path                = "/"
    interval            = 60
    matcher             = 200
  }

  tags = { Name = "jn-tg" }
}

resource "aws_lb_target_group" "web_tg" {
  name                 = "web-tg"
  port                 = 8080
  protocol             = "HTTP"
  vpc_id               = aws_vpc.fofun_vpc.id
  deregistration_delay = 5

  health_check {
    port                = 8080
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 3
    path                = "/"
    interval            = 60
    matcher             = 200
  }

  tags = {
    Name = "web-tg"
  }
}

resource "aws_lb_target_group_attachment" "jn_tg_atch" {
  target_group_arn = aws_lb_target_group.jn_tg.arn
  target_id        = aws_instance.web_server.id
  port             = 8080
}

resource "aws_lb_target_group_attachment" "web_tg_atch" {
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = aws_instance.web_server.id
  port             = 80
}

resource "aws_lb_listener" "fofun_listener_https" {
  load_balancer_arn = aws_lb.fofun_elb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.fofun_ssl.arn
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2020-10"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

resource "aws_lb_listener_rule" "jn_rule" {
  listener_arn = aws_lb_listener.fofun_listener_https.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jn_tg.arn
  }

  condition {
    host_header {
      values = ["cicd.iplatinum.pro"]
    }
  }
}