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
  type = string
  description = "Bastion Key pair"
  default = "Daegok_bastion_pub"
}

variable "jenkins_key_name" {
  type = string
  description = "Jenkins Key pair"
  default = "Daegok_Jenkins_pub"
}

#################################################################################
################################## vpc_2_id #####################################
#################################################################################

variable "Service_VPC_id" {
  type = string
  description = "Service VPC ID"
}

variable "Jenkins_VPC_id" {
  type = string
  description = "Jenkins VPC ID"
}

#################################################################################
################################## IGW #####################################
#################################################################################

variable "internet_gateway_Jenkins_id" {
  type = string
  description = "IGW of Bastion Route Table"
}

#################################################################################
################################## SG #####################################
#################################################################################

variable "bastion_sg_id" {
  type        = string
  description = "Bastion Security Group"

}

variable "jenkins_sg_id" {
  type        = string
  description = "Jenkins Security Group"
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

############################ 계속 추가 예정 #################################
