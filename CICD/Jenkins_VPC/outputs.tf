#################################################################################
############################### Jenkins VPC #####################################
#################################################################################

output "Jenkins_VPC_id" {
  value = aws_vpc.Jenkins_VPC.id  
  description = "Jenkins VPC ID"
}

output "Jenkins_VPC_cidr" {
  value = aws_vpc.Jenkins_VPC.cidr_block
  description = "Jenkins VPC CIDR"
}

output "Jenkins_VPC_dns_support" {
  value = aws_vpc.Jenkins_VPC.enable_dns_support    
  description = "Whether DNS resolution is supported for the Jenkins VPC"
}

output "Jenkins_VPC_dns_hostnames" {
  value = aws_vpc.Jenkins_VPC.enable_dns_hostnames   
  description = "Whether DNS hostnames are enabled for the Jenkins VPC"
}

#################################################################################
################################ Subnet ID ######################################
#################################################################################

############################## Public Subnet ID #################################

output "bastion_subnet_id" {
  value = aws_subnet.bastion_subnet.id
  description = "Jenkins VPC bastion subnet ID"
}

############################## Private Subnet ID #################################

output "jenkins_subnet_id" {
  value = aws_subnet.jenkins_subnet.id
  description = "Jenkins VPC jenkins subnet ID"
}

#################################################################################
########################### Internet Gateway ID #################################
#################################################################################

output "internet_gateway_Jenkins_id" {
  value = aws_internet_gateway.internet_gateway_Jenkins.id
  description = "Jenkins VPC Internet Gateway ID"
}

#################################################################################
############################# NAT Gateway ID ####################################
#################################################################################

output "nat_gateway_id" {
  value = aws_nat_gateway.nat_gateway.id
  description = "Jenkins VPC Nat Gateway ID"
}

#################################################################################
############################# Route Table ID ####################################
#################################################################################

output "public_route_table_id" {
  value       = aws_route_table.route_table_bastion.id
  description = "Public Route Table ID for Bastion VPC"
}

output "private_route_table_id" {
  value       = aws_route_table.route_table_jenkins.id
  description = "Private Route Table ID for Jenkins VPC"
}
