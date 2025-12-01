resource "aws_lb_listener" "blue_listener" {
  load_balancer_arn = aws_lb.Daegok_alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }
}

resource "aws_lb_listener" "green_listener" {
  load_balancer_arn = aws_lb.Daegok_alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.green.arn
  }
}
