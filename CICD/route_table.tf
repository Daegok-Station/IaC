#################################################################################
################################### VPC CIDR ####################################
#################################################################################

variable "vpc_1_cidr" {
  type = string          
  default = "10.1.0.0/16"       # VPC IPv4 주소 범위
  description = "VPC_1 CIDR"    # Terraform 문서화 및 CLI 출력용 설명
}

#################################################################################
################################ Subnet CIDR ####################################
#################################################################################

######################### Public/Private subnet 01 CIDR #########################

variable "public_subnet_cidr_01" {
  type = string
  default = "10.1.0.0/24"       # Public Subnet 01 IPv4 주소 범위
  description = "VPC 1 Public Subnet 01 CIDR"
}

variable "private_subnet_cidr_01" {
  type = string
  default = "10.1.1.0/24"       # Private Subnet 01 IPv4 주소 범위
  description = "VPC 1 Private Subnet 01 CIDR"
}

######################### Public/Private subnet 02 CIDR #########################

variable "public_subnet_cidr_02" {
  type = string
  default = "10.1.2.0/24"       # Public Subnet 02 IPv4 주소 범위
  description = "VPC 1 Public Subnet 02 CIDR"
}

variable "private_subnet_cidr_02" {
  type = string
  default = "10.1.3.0/24"       # Private Subnet 02 IPv4 주소 범위
  description = "VPC 1 Private Subnet 02 CIDR"
}

#################################################################################
#################################### AZ #########################################
#################################################################################

################# Public/Private subnet 01 가용 영역(AZ) #########################

variable "availability_zone_01" {
  type = string
  default = "ap-northeast-2b"
  description = "VPC 1 Public/Private Subnet 01 AZ"
}

################# Public/Private subnet 02 가용 영역(AZ) #########################

variable "availability_zone_02" {
  type = string
  default = "ap-northeast-2c"
  description = "VPC 1 Public/Private Subnet 02 AZ"
}
