#################################################################################
##################################### vpc #######################################
#################################################################################

output "vpc_id" {
    value = aws_vpc.vpc_1.id    # VPC_1 ID 출력
    description = "VPC 1 ID"
}

output "vpc_dns_support" {
  value = aws_vpc.vpc_1.enable_dns_support    # VPC 내 DNS 해석 기능 활성화 여부 출력
  description = "Whether or not the VPC has DNS support"
}

output "vpc_dns_hostnames" {
  value = aws_vpc.vpc_1.enable_dns_hostnames  # VPC 내 DNS 호스트 네임 기능 활성화 여부 출력
  description = "Whether or not the VPC has DNS hostname support"
}

#################################################################################
################################## Subnet #######################################
#################################################################################

###################### Public/Private subnet id 01 ##############################

output "public_subnet_id_01" {
    value = aws_subnet.public_subnet_01.id      # Public Subnet 01 ID 출력
    description = "VPC 1 Public Subnet 01 ID"
}

output "private_subnet_id_01" {
    value = aws_subnet.private_subnet_01.id     # Private Subnet 01 ID 출력
    description = "VPC 1 Private Subnet 01 ID"
}

##################### Public/Private subnet id 02 ##############################

output "public_subnet_id_02" {
    value = aws_subnet.public_subnet_02.id      # Public Subnet 02 ID 출력
    description = "VPC 1 Public Subnet 02 ID"
}

output "private_subnet_id_02" {
    value = aws_subnet.private_subnet_02.id     # Private Subnet 02 ID 출력
    description = "VPC 1 Private Subnet 02 ID"
}

#################################################################################
############################ Internet gateway ###################################
#################################################################################

output "internet_gateway_id" {
    value = aws_internet_gateway.internet_gateway_01.id
    description = "Internet Gateway ID"
}

#################################################################################
################################ Nat gateway ####################################
#################################################################################

output "nat_gateway_id_01" {
    value = aws_nat_gateway.nat_gateway_01.id
    description = "VPC 1 Nat gateway 01 ID"
}

output "nat_gateway_id_02" {
    value = aws_nat_gateway.nat_gateway_02.id
    description = "VPC 1 Nat gateway 02 ID"
}

#################################################################################
################################ Route Table ####################################
#################################################################################

############################## Public Route Table ################################

output "route_table_public_id_01" {
    value = aws_route_table.route_table_public_01.id
    description = "VPC 1 Public Route Table ID"
}

output "route_table_public_id_02" {
    value = aws_route_table.route_table_public_02.id
    description = "VPC 1 Public Route Table ID"
}

############################## Private Route Table ###############################

output "route_table_private_id_01" {
    value = aws_route_table.route_table_private_01.id
    description = "VPC 1 private Route Table ID"
}

output "route_table_private_id_02" {
    value = aws_route_table.route_table_private_02.id
    description = "VPC 1 private Route Table ID"
}
