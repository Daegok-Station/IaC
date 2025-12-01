#################################################################################
#################################### VPC ID #####################################
#################################################################################

variable "Service_VPC_id" {
  type = string
  description = "Service VPC ID"
}

variable "Jenkins_VPC_id" {
  type = string
  description = "Jenkins VPC ID"
}

variable "Service_VPC_cidr" {
  type        = string
  description = "The CIDR block of the Service VPC, used for defining ALB SG egress rules to internal targets."
}

variable "Jenkins_VPC_cidr" {
  type = string
}

#################################################################################
################################ Subnet ID ###################################
#################################################################################

variable "bastion_subnet_id" {
  type = string
  description = "Jenkins VPC Bastion Subnet ID"
}

variable "jenkins_subnet_id" {
  type = string
  description = "Jenkins VPC Jenkins Subnet ID"
}

#################################################################################
################################ key pair ###################
#################################################################################

variable "bastion_key_name" {
  type        = string
  description = "Bastion Key Name"
}

variable "jenkins_key_name" {
  type        = string
  description = "jenkins Key Name"
}

#################################################################################
################################## IGW #####################################
#################################################################################

variable "internet_gateway_Jenkins_id" {
  type = string
  description = "Bastion IGW"
}

#################################################################################
################################## SG #####################################
#################################################################################

variable "bastion_sg_id" {
  type = string
  description = "Bastion Security Group"
}

variable "jenkins_sg_id" {
  type = string
  description = "Jenkins Security Group"
}

variable "alb_sg_id" {
  type = string
}

#################################################################################
################################ Route Table ####################################
#################################################################################

variable "public_route_table_id" {
  type = string
  description = "Jenkins VPC Public Route Table"
}
variable "private_route_table_id" {
  type = string
  description = "Jenkins VPC Private Route Table"
}

#################################################################################
################################## Policy #######################################
#################################################################################

variable "alb_policy_json" {
  type        = string
  description = "ALB IAM Policy JSON"
  default = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ELBReadOperations",
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:DescribeListeners",
        "elasticloadbalancing:DescribeRules",
        "elasticloadbalancing:DescribeTargetGroups",
        "elasticloadbalancing:DescribeTargetHealth"
      ],
      "Resource": "*"
    },
    {
      "Sid": "TargetGroupOperations",
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:RegisterTargets",
        "elasticloadbalancing:DeregisterTargets"
      ],
      "Resource": "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*"
    },
    {
      "Sid": "ALBModifyListeners",
      "Effect": "Allow",
      "Action": "elasticloadbalancing:ModifyListener",
      "Resource": [
        "arn:aws:elasticloadbalancing:*:*:listener/app/*/*/*"
      ]
    },
    {
      "Sid": "NLBModifyListeners",
      "Effect": "Allow",
      "Action": "elasticloadbalancing:ModifyListener",
      "Resource": [
        "arn:aws:elasticloadbalancing:*:*:listener/net/*/*/*"
      ]
    },
    {
      "Sid": "ALBModifyRules",
      "Effect": "Allow",
      "Action": "elasticloadbalancing:ModifyRule",
      "Resource": [
        "arn:aws:elasticloadbalancing:*:*:listener-rule/app/*/*/*/*"
      ]
    }
  ]
}
POLICY
}


variable "ecs_add_role_policy_json" {
  type        = string
  description = "ECS 관련 커스텀 정책 JSON"
  default     = <<JSON
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:CreateService",
        "ecs:UpdateService",
        "ecs:DeleteService"
      ],
      "Resource": "*"
    }
  ]
}
JSON
}

variable "jenkins_ecs_policy_json" {
  type        = string
  description = "Jenkins 관련 커스텀 정책 JSON"
  default     = <<JSON
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:RunTask",
        "ecs:DescribeTasks",
        "ecs:StopTask"
      ],
      "Resource": "*"
    }
  ]
}
JSON
}
