variable "codedeploy_role_arn" {
  type        = string
  description = "CodeDeploy service role ARN from IAM module"
}

variable "blue_listener_arn" {
  type        = string
  description = "Blue listener ARN received from the ALB module."
}

variable "green_listener_arn" {
  type        = string
  description = "Blue listener ARN received from the ALB module."
}
