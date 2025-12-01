variable "Service_VPC_id" {
  type = string
}

variable "private_subnet_id_01" {
  type = string
  description = "Private subnet for ECS tasks"
}

variable "app_alb_arn" {
  type = string
}

variable "ecr_repository_url" {
  description = "ECR repository URL"
  type        = string
}

variable "blue_listener_arn" {
  type        = string
  description = "Blue listener ARN received from the ALB module."
}

variable "green_listener_arn" {
  type        = string
  description = "Blue listener ARN received from the ALB module."
}

variable "blue_tg_arn" {
  type        = string
  description = "ARN of the Blue Target Group received from the ALB module."
}

variable "green_tg_arn" {
  type        = string
  description = "ARN of the Green Target Group received from the ALB module."
}

variable "ecs_task_execution_role_arn" {
  type        = string
  description = "ARN for the ECS Task Execution Role."
}

variable "ecs_service_role_arn" {
  type        = string
  description = "ARN for the ECS Service Role."
}
