#################################################################################
################################### VPC CIDR ####################################
#################################################################################

variable "Service_VPC_cidr" {
  type = string          
  default = "10.1.0.0/16"             # VPC IPv4 주소 범위
  description = "Service VPC CIDR"    # Terraform 문서화 및 CLI 출력용 설명
}

#################################################################################
################################ Subnet CIDR ####################################
#################################################################################

######################### Public/Private subnet 01 CIDR #########################

variable "public_subnet_cidr_01" {
  type = string
  default = "10.1.0.0/24"       # Public Subnet 01 IPv4 주소 범위
  description = "Service VPC Public Subnet 01 CIDR"
}

variable "private_subnet_cidr_01" {
  type = string
  default = "10.1.1.0/24"       # Private Subnet 01 IPv4 주소 범위
  description = "Service VPC Private Subnet 01 CIDR"
}

######################### Public/Private subnet 02 CIDR #########################

variable "public_subnet_cidr_02" {
  type = string
  default = "10.1.2.0/24"       # Public Subnet 02 IPv4 주소 범위
  description = "Service VPC Public Subnet 02 CIDR"
}

variable "private_subnet_cidr_02" {
  type = string
  default = "10.1.3.0/24"       # Private Subnet 02 IPv4 주소 범위
  description = "Service VPC Private Subnet 02 CIDR"
}

#################################################################################
#################################### AZ #########################################
#################################################################################

################# Public/Private subnet 01 가용 영역(AZ) #########################

variable "availability_zone_01" {
  type = string
  default = "ap-northeast-2a"
  description = "Service VPC Public/Private 01 AZ"
}

################# Public/Private subnet 02 가용 영역(AZ) #########################

variable "availability_zone_02" {
  type = string
  default = "ap-northeast-2c"
  description = "Service VPC Public/Private 02 AZ"
}
