###############################
#   Public Load Balancer      #
###############################
resource "aws_lb" "fofun-elb" {
  name               = "fofun-elb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.fofun-sn1.id, aws_subnet.fofun-sn2.id]
  security_groups    = [aws_security_group.elb-fofun-sg.id]

  tags = {
    Name = "fofun-elb"
  }
}

resource "aws_lb_target_group" "jn-tg" {
  name                 = "jn-tg"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = aws_vpc.fofun-vpc.id
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

  tags = {
    Name = "jn-tg"
  }
}

resource "aws_lb_target_group" "web-tg" {
  name                 = "web-tg"
  port                 = 8080
  protocol             = "HTTP"
  vpc_id               = aws_vpc.fofun-vpc.id
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

resource "aws_lb_target_group_attachment" "jn-tg-atch" {
  target_group_arn = aws_lb_target_group.jn-tg.arn
  target_id        = aws_instance.web-server.id
  port             = 8080
}

resource "aws_lb_target_group_attachment" "web-tg-atch" {
  target_group_arn = aws_lb_target_group.web-tg.arn
  target_id        = aws_instance.web-server.id
  port             = 80
}

resource "aws_lb_listener" "fofun-listener-https" {
  load_balancer_arn = aws_lb.fofun-elb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = "arn:aws:acm:eu-central-1:875450339477:certificate/23f54c60-a800-4d71-80aa-40fc4b8a5898"
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2020-10"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web-tg.arn
  }
}

resource "aws_lb_listener_rule" "static" {
  listener_arn = aws_lb_listener.fofun-listener-https.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jn-tg.arn
  }

  condition {
    host_header {
      values = ["cicd.iplatinum.pro"]
    }
  }
}