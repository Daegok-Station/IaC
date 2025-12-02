variable "public_subnet_id_01" {
  type = string
  description = "Public subnet for ECS tasks"
}

variable "public_subnet_id_02" {
  type = string
  description = "Public subnet for ECS tasks"
}

variable "Service_VPC_id" {
  type = string
  description = "Service VPC ID"
}

variable "jenkins_sg_id" {
  type        = string
  description = "Jenkins Security Group ID for ALB rules."
}

variable "Service_VPC_cidr" {
  type = string
}

