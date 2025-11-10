#################################################################################
#################################### vpc_1 ######################################
#################################################################################

resource "aws_vpc" "vpc_1" {
  cidr_block = var.vpc_1_cidr     # VPC의 IPv4 주소 범위
  instance_tenancy = "default"    # 기본 테넌시 (AWS 공유 인프라에서 실행)

  enable_dns_hostnames = true     # VPC 내 리소스에 DNS 부여
  enable_dns_support = true       # VPC에서 내부에서 DNS 사용 가능

  tags = {
    Name = "Daegok-VPC-Service"   # VPC 이름
  }
}

#################################################################################
################################## subnet #######################################
#################################################################################

######################## Public/Private subnet 01 ###############################

resource "aws_subnet" "public_subnet_01" {         
  vpc_id = aws_vpc.vpc_1.id                     # VPC 선택
  cidr_block = var.public_subnet_cidr_01        # Public Subnet 01 CIDR
  availability_zone = var.availability_zone_01  # 가용 영역(AZ 01)
  map_public_ip_on_launch = true                # 퍼블릭 IP 자동 할당 활성화

  tags = {
    Name = "Daegok-public-subnet-1"             # Public Subnet 01 이름
  }
}

resource "aws_subnet" "private_subnet_01" {
  vpc_id = aws_vpc.vpc_1.id                     # VPC 선택
  cidr_block = var.private_subnet_cidr_01       # Private Subnet 02 CIDR
  availability_zone = var.availability_zone_01  # 가용 영역(AZ 01)
  map_public_ip_on_launch = false               # 퍼블릭 IP 자동 할당 비활성화

  tags = {
    Name = "Daegok-private-subnet-1"            # Private Subnet 01 이름
  }
}

######################## Public/Private subnet 02 ###############################

resource "aws_subnet" "public_subnet_02" {
  vpc_id = aws_vpc.vpc_1.id                     # VPC 선택
  cidr_block = var.public_subnet_cidr_02        # Public Subnet 02 CIDR
  availability_zone = var.availability_zone_02  # 가용 영역(AZ 02)
  map_public_ip_on_launch = true                # 퍼블릭 IP 자동 할당 활성화

  tags = {
    Name = "Daegok-public-subnet-2"             # Public Subnet 02 이름
  }
}

resource "aws_subnet" "private_subnet_02" {
  vpc_id = aws_vpc.vpc_1.id                     # VPC 선택
  cidr_block = var.private_subnet_cidr_02       # Private Subnet 02 CIDR
  availability_zone = var.availability_zone_02  # 가용 영역(AZ 02)
  map_public_ip_on_launch = false               # 퍼블릭 IP 자동 할당 비활성화

  tags = {
    Name = "Daegok-private-subnet-2"            # Private Subnet 02 이름
  }
}

#################################################################################
############################ Internet gateway ###################################
#################################################################################

resource "aws_internet_gateway" "internet_gateway_01" {
  vpc_id = aws_vpc.vpc_1.id       # VPC 선택

  tags = {
    Name = "Daegok-igw-Service"   # Internet gateway 01 이름
  }
}

#################################################################################
################################ Nat gateway ####################################
#################################################################################

######################### Nat gateway 01 / Elastic IP ###########################

resource "aws_eip" "nat_eip_01" {
  domain = "vpc"                # VPC 기반 EIP 설정
  tags = { 
    Name = "Daegok-ngw-eip-1"   # EIP 01 이름     
    }  
}

resource "aws_nat_gateway" "nat_gateway_01" {
  allocation_id = aws_eip.nat_eip_01.id         # EIP 01 연결
  subnet_id = aws_subnet.public_subnet_01.id    # Public Subnet 내에 배치
  connectivity_type = "public"                  # 인터넷 연결 허용
  tags = {
    Name = "Daegok-ngw-1"                       # NAT Gateway 01 이름
  }
}

######################### Nat gateway 02 / Elastic IP ###########################

resource "aws_eip" "nat_eip_02" {
  domain = "vpc"                # VPC 기반 EIP 설정
  tags = { 
    Name = "Daegok-ngw-eip-2"   # EIP 02 이름
    }
}

resource "aws_nat_gateway" "nat_gateway_02" {
  allocation_id = aws_eip.nat_eip_02.id         # EIP 02 연결
  subnet_id = aws_subnet.public_subnet_02.id    # # Public Subnet 내에 배치
  connectivity_type = "public"                  # 인터넷 연결 허용

  tags = {
    Name = "Daegok-ngw-2"                       # NAT Gateway 02 이름
  }
}
