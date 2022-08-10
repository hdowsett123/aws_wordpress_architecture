resource "aws_lb" "frontends" {
  name                             = "Edge-frontends"
  internal                         = false
  load_balancer_type               = "application"
  security_groups                  = [aws_security_group.edge-frontends-alb.id]
  subnets                          = [aws_subnet.wordpress-public-1a.id, aws_subnet.wordpress-public-1b.id]
  enable_cross_zone_load_balancing = true

  enable_deletion_protection = true

  access_logs {
    bucket  = "harrydowsettresume-logs-${var.tier}"
    prefix  = "frontends"
    enabled = true
  }

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.frontends.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.alb_target.arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.frontends.arn
  port              = 443
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.alb_target.arn
    type             = "forward"
  }
}

resource "aws_alb_target_group" "alb_target" {
  name     = var.edge_target_group_name
  port     = "80"
  protocol = "HTTP"
  vpc_id   = aws_vpc.harrydowsettresume_wordpress.id
  tags = {
    name = var.edge_target_group_name
  }
  stickiness {
    type            = "lb_cookie"
    cookie_duration = 1800
    enabled         = true
  }
}
