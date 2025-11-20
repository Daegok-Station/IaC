#################################################################################
################################# VPC_2 CIDR ####################################
#################################################################################

variable "Jenkins_VPC_cidr" {
  type = string          
  default = "10.0.0.0/16"         # VPC IPv4 주소 범위
  description = "Jenkins VPC CIDR"      # Terraform 문서화 및 CLI 출력용 설명
}

#################################################################################
################################ Subnet CIDR ####################################
#################################################################################

############################### Public subnet CIDR ##############################

variable "bastion_subnet_cidr" {
  type = string
  default = "10.0.1.0/24"       # Public Subnet IPv4 주소 범위
  description = "Daegok-public-subnet-1 CIDR"
}

############################### Private subnet CIDR ##############################

variable "jenkins_subnet_cidr" {
  type = string
  default = "10.0.2.0/24"       # Private Subnet IPv4 주소 범위
  description = "Daegok-private-subnet-1 CIDR"
}

#################################################################################
#################################### AZ #########################################
#################################################################################

################### Public/Private subnet 가용 영역(AZ) ##########################

variable "availability_zone_Jenkins_VPC" {
  type        = string
  default     = "ap-northeast-2c"
  description = "Jenkins VPC bastion/jenkins AZ"
}
