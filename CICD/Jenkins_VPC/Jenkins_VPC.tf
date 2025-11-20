#################################################################################
#################################### vpc_2 ######################################
#################################################################################

resource "aws_vpc" "Jenkins_VPC" {
  cidr_block = var.Jenkins_VPC_cidr       # VPC IPv4 주소 범위
  instance_tenancy = "default"      # 기본 테넌시 (AWS 공유 인프라에서 실행)

  enable_dns_hostnames = true       # VPC 내 리소스에 DNS 부여
  enable_dns_support = true         # VPC에서 내부에서 DNS 사용 가능

  tags = {
    Name = "Daegok-VPC-Jenkins"   
  }
}

#################################################################################
################################## subnet #######################################
#################################################################################

############################### Public subnet ###################################

resource "aws_subnet" "bastion_subnet" {         
  vpc_id = aws_vpc.Jenkins_VPC.id                     # VPC 선택
  cidr_block = var.bastion_subnet_cidr     # Public Subnet CIDR
  availability_zone = var.availability_zone_Jenkins_VPC  # 가용 영역(AZ v2)
  map_public_ip_on_launch = true                # 퍼블릭 IP 자동 할당 활성화

  tags = {
    Name = "Daegok-public-subnet-Jenkins"
  }
}

############################## Private subnet ##################################

resource "aws_subnet" "jenkins_subnet" {
  vpc_id = aws_vpc.Jenkins_VPC.id                     # VPC 선택
  cidr_block = var.jenkins_subnet_cidr     # Private Subnet CIDR
  availability_zone = var.availability_zone_Jenkins_VPC  # 가용 영역(AZ v2)
  map_public_ip_on_launch = false               # 퍼블릭 IP 자동 할당 비활성화

  tags = {
    Name = "Daegok-private-subnet-Jenkins"
  }
}

#################################################################################
############################ Internet gateway ###################################
#################################################################################

resource "aws_internet_gateway" "internet_gateway_Jenkins" {
  vpc_id = aws_vpc.Jenkins_VPC.id         # VPC 선택

  tags = {
    Name = "Daegok-igw-Jenkins"  
  }
}

#################################################################################
################################ Nat gateway ####################################
#################################################################################

############################ Nat gateway / Elastic IP ###########################

resource "aws_eip" "nat_eip" {
  domain = "vpc"                        # VPC 기반 EIP 설정
  tags = { Name = "Daegok-ngw-eip" }    # EIP 이름
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id            # EIP 연결
  subnet_id = aws_subnet.bastion_subnet.id       # Public Subnet 내에 배치
  connectivity_type = "public"                  # 인터넷 연결 허용

  tags = {
    Name = "Daegok-ngw-Jenkins"            
  }
}

#################################################################################
################################ Route Table ####################################
#################################################################################

############################# Public Route Table ################################

resource "aws_route_table" "route_table_bastion" {
  vpc_id = aws_vpc.Jenkins_VPC.id     # VPC_1 선택

  # Route 규칙
  route {
    cidr_block = "0.0.0.0/0"                                        # 모든 IPv4 트래픽을
    gateway_id = aws_internet_gateway.internet_gateway_Jenkins.id   # Internet Gateway로 전달 (인터넷 통신)
  }

  tags = {
    Name = "Daegok-public-table-Jenkins"                        
  }
}

# Public Subnet과 Route Table 연결
resource "aws_route_table_association" "route_table_publicconn" {
  subnet_id = aws_subnet.bastion_subnet.id                         
  route_table_id = aws_route_table.route_table_bastion.id   
}

############################# Private Route Table ################################

resource "aws_route_table" "route_table_jenkins" {
  vpc_id = aws_vpc.Jenkins_VPC.id     # VPC_1 선택
  
  # Route 규칙
  route {
    cidr_block = "0.0.0.0/0"                            # 모든 IPv4 트래픽을
    nat_gateway_id = aws_nat_gateway.nat_gateway.id     # NAT Gateway로 전달 (Private Submet 외부 통신)
  }

  tags = {
    Name = "Daegok-private-table-Jenkins"               # Private Route Table 이름
  }
}

# Public Subnet과 Route Table 연결
resource "aws_route_table_association" "route_table_privateconn" {
  subnet_id = aws_subnet.jenkins_subnet.id
  route_table_id = aws_route_table.route_table_jenkins.id
}
