resource "aws_lb_target_group" "blue" {
  name = "Daegok-blue"
  port = 80
  protocol = "HTTP"
  target_type = "ip"
  vpc_id = var.Service_VPC_id

  health_check {
    path = "/actuator/health" 
    protocol= "HTTP"
    port = "traffic-port"
    matcher = "200"
    interval = 30
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group" "green" {
  name = "Daegok-green"
  port = 80
  protocol = "HTTP"
  target_type = "ip"
  vpc_id = var.Service_VPC_id

  health_check {
    path = "/actuator/health" 
    protocol= "HTTP"
    port = "traffic-port"
    matcher = "200"
    interval = 30
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}
