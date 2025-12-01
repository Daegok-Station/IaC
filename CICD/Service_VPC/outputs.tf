#################################################################################
################################ Serivce VPC ####################################
#################################################################################

output "Service_VPC_id" {
    value = aws_vpc.Service_VPC.id  
    description = "The ID of the Service VPC"
}

output "Service_VPC_dns_support" {
  value = aws_vpc.Service_VPC.enable_dns_support 
  description = "Whether DNS resolution is supported for the Service VPC"
}

output "Service_VPC_dns_hostnames" {
  value = aws_vpc.Service_VPC.enable_dns_hostnames  
  description = "Whether DNS hostnames are enabled for the Service VPC"
}

output "Service_VPC_cidr" {                
  value = aws_vpc.Service_VPC.cidr_block
  description = "Service VPC CIDR"    
}

#################################################################################
################################## Subnet #######################################
#################################################################################

###################### Public/Private subnet id 01 ##############################

output "public_subnet_id_01" {
    value = aws_subnet.public_subnet_01.id      
    description = "Service VPC Public Subnet 01 ID"
}

output "private_subnet_id_01" {
    value = aws_subnet.private_subnet_01.id   
    description = "Service VPC Private Subnet 01 ID"
}

##################### Public/Private subnet id 02 ##############################

output "public_subnet_id_02" {
    value = aws_subnet.public_subnet_02.id    
    description = "Service VPC Public Subnet 02 ID"
}

output "private_subnet_id_02" {
    value = aws_subnet.private_subnet_02.id    
    description = "Service VPC Private Subnet 01 ID"
}

#################################################################################
############################ Internet Gateway ###################################
#################################################################################

output "internet_gateway_Service_id" {
    value = aws_internet_gateway.internet_gateway_Service.id
    description = "Service VPC Internet Gateway ID"
}

#################################################################################
################################ Nat Gateway ####################################
#################################################################################

output "nat_gateway_id_01" {
    value = aws_nat_gateway.nat_gateway_01.id
    description = "Service VPC Nat Gateway 01 ID"
}

output "nat_gateway_id_02" {
    value = aws_nat_gateway.nat_gateway_02.id
    description = "Service VPC Nat Gateway 02 ID"
}

#################################################################################
################################ Route Table ####################################
#################################################################################

############################## Public Route Table ################################

output "route_table_public_01_id" {
    value = aws_route_table.route_table_public_01.id
    description = "Service VPC Public Route Table 01 ID"
}

output "route_table_public_02_id" {
    value = aws_route_table.route_table_public_02.id
    description = "Service VPC Public Route Table 02 ID"
}

############################## Private Route Table ###############################

output "route_table_private_01_id" {
    value = aws_route_table.route_table_private_01.id
    description = "Service VPC Private Route Table 01 ID"
}

output "route_table_private_02_id" {
    value = aws_route_table.route_table_private_02.id
    description = "Service VPC Private Route Table 02 ID"
}
