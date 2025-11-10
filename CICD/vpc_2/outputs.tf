#################################################################################
##################################### VPC_2 #####################################
#################################################################################

output "vpc_2_id" {
  value = aws_vpc.vpc_2.id    # VPC_2 ID 출력
  description = "VPC 2 ID"
}

output "vpc_2_dns_support" {
  value = aws_vpc.vpc_2.enable_dns_support        # VPC 내 DNS 해석 기능 활성화 여부 출력
  description = "Whether or not VPC 2 has DNS support"
}

output "vpc_2_dns_hostnames" {
  value = aws_vpc.vpc_2.enable_dns_hostnames      # VPC 내 DNS 호스트 네임 기능 활성화 여부 출력
  description = "Whether or not VPC 2 has DNS hostname support"
}

#################################################################################
################################### Subnet ######################################
#################################################################################

############################## Public Subnet ID #################################

output "vpc_2_public_subnet_id" {
  value = aws_subnet.public_subnet.id     # Public Subnet ID 출력
  description = "VPC 2 Public Subnet ID"
}

############################## Private Subnet ID #################################

output "vpc_2_private_subnet_id" {
  value = aws_subnet.private_subnet.id    # Private Subnet ID 출력
  description = "VPC 2 Private Subnet ID"
}

#################################################################################
############################ Internet Gateway ###################################
#################################################################################

output "internet_gateway_id_02" {
  value = aws_internet_gateway.internet_gateway_02.id
  description = "Internet Gateway 02 ID"
}

#################################################################################
############################### NAT Gateway ####################################
#################################################################################

output "nat_gateway_id" {
  value = aws_nat_gateway.nat_gateway.id
  description = "VPC 2 Nat gateway ID"
}

output "nat_eip_id" {
  value = aws_eip.nat_eip.id
  description = "VPC 2 EIP ID"
}
