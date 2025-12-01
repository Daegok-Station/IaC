output "app_alb_arn" {
  value = aws_lb.Daegok_alb.arn
  description = "ARN of the Application Load Balancer"
}

output "blue_target_group_arn" {
  value = aws_lb_target_group.blue.arn
}

output "green_target_group_arn" {
  value = aws_lb_target_group.green.arn
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "blue_listener_arn" {
  value = aws_lb_listener.blue_listener.arn
}
output "green_listener_arn" {
  value = aws_lb_listener.green_listener.arn
}

output "blue_tg_arn" {
  description = "ARN of the Blue Target Group."
  value       = aws_lb_target_group.blue.arn 
}

output "green_tg_arn" {
  description = "ARN of the Green Target Group."
  value       = aws_lb_target_group.green.arn
}
