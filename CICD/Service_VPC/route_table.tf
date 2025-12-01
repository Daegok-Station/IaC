#################################################################################
################################ Route Table ####################################
#################################################################################

############################# Public Route Table ################################

resource "aws_route_table" "route_table_public_01" {
  vpc_id = aws_vpc.Service_VPC.id     

  route {
    cidr_block = "0.0.0.0/0"                                        # 모든 IPv4 트래픽을
    gateway_id = aws_internet_gateway.internet_gateway_Service.id   # Internet Gateway로 전달
  }

  tags = {
    Name = "Daegok-public-table-1"                                 
  }
}

resource "aws_route_table" "route_table_public_02" {
  vpc_id = aws_vpc.Service_VPC.id    

  route {
    cidr_block = "0.0.0.0/0"                                        # 모든 IPv4 트래픽을
    gateway_id = aws_internet_gateway.internet_gateway_Service.id   # Internet Gateway로 전달
  }

  tags = {
    Name = "Daegok-public-table-2"                                 
  }
}

######################## Public Subnet & Route Table 연결 #######################

resource "aws_route_table_association" "route_table_publicconn_01" {
  subnet_id = aws_subnet.public_subnet_01.id                         
  route_table_id = aws_route_table.route_table_public_01.id   
}

resource "aws_route_table_association" "route_table_publicconn_02" {
  subnet_id = aws_subnet.public_subnet_02.id                         
  route_table_id = aws_route_table.route_table_public_02.id   
}

############################ Private Route Table ################################

resource "aws_route_table" "route_table_private_01" {
  vpc_id = aws_vpc.Service_VPC.id    
  
  route {
    cidr_block = "0.0.0.0/0"                                       # 모든 IPv4 트래픽을
    nat_gateway_id = aws_nat_gateway.nat_gateway_01.id             # NAT Gateway로 전달 
  }

  tags = {
    Name = "Daegok-private-table-1"                            
  }
}

resource "aws_route_table" "route_table_private_02" {
  vpc_id = aws_vpc.Service_VPC.id   
  
  route {
    cidr_block = "0.0.0.0/0"                                      # 모든 IPv4 트래픽을
    nat_gateway_id = aws_nat_gateway.nat_gateway_02.id            # NAT Gateway로 전달 
  }

  tags = {
    Name = "Daegok-private-table-2"                             
  }
}

######################## Private Subnet & Route Table 연결 ######################

resource "aws_route_table_association" "route_table_privateconn_01" {
  subnet_id = aws_subnet.private_subnet_01.id
  route_table_id = aws_route_table.route_table_private_01.id
}

resource "aws_route_table_association" "route_table_privateconn_02" {
  subnet_id = aws_subnet.private_subnet_02.id
  route_table_id = aws_route_table.route_table_private_02.id
}
