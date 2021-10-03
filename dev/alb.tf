/*
  alb
*/
resource "aws_lb" "web" {
  name               = "alb-for-web"
  internal           = false //tureなら内部LBになる
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  enable_deletion_protection = false //trueならterraformでlbを削除できなくなる。現状はfalseで良い

  access_logs {
    bucket  = aws_s3_bucket.alb_logs.bucket
    prefix  = "logs"
    enabled = true
  }

  tags = {
    Environment = var.env
  }
}

/*
  リスナールール

  FIX: 443に対応する設定とacmの作成を！ + domeinの作成を！
*/
resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

resource "aws_lb_listener_rule" "for_web" {
  listener_arn = aws_lb_listener.web.arn

   condition {
    host_header {
      values = ["example.com"]
    }
  }
  
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

/*
  ターゲットグループ
*/
resource "aws_lb_target_group" "web" {
  name     = "target-group-for-web"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.app_env.id

  stickiness {
    type            = "lb_cookie" //クライアントからの要求を同じターゲットにルーティングする必要がある時間（秒単位）。
    cookie_duration = 600
    enabled         = false
  }

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 2
    path                = "/healthcheck"
  }

  tags = {
    Group      = var.project
    Enviroment = var.env
  }
}
