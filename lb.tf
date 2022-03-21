resource "aws_lb" "elb" {
  name               = "external-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web-sgrp.id]
  subnets            = [aws_subnet.public-1.id, aws_subnet.public-2.id]
}


resource "aws_lb_target_group" "web_servers" {
  name     = "web-servers-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.elb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_servers.arn
  }
}
