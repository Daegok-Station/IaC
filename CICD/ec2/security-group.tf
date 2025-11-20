#################################################################################
################################### Bastion SG ##################################
#################################################################################

resource "aws_security_group" "bastion_sg" {
  name = "Daegok-Bastion-SG"                     # SG 이름 (콘솔)
  description = "Bastion EC2 security group"     # Public Subnet EC2용 보안 그룹
  vpc_id = var.Jenkins_VPC_id                    # Jenkins VPC 선택
  
  ## 인바운드 규칙
  # SSH 허용 (모든 IP)
  ingress {
    from_port   = 22              # 허용 시작 포트
    to_port     = 22              # 허용 끝 포트
    protocol    = "tcp"           # 
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 모든 트래픽 허용 (모든 IP)
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ## 아웃바운드 규칙
  # 모든 트래픽 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Daegok-Bastion-SG"    
  }
}

#################################################################################
################################ Jenkins SG #####################################
#################################################################################

resource "aws_security_group" "jenkins_sg" {
  name = "Daegok-Jenkins-SG"                            # SG 이름 (콘솔)
  description = "Jenkins EC2 security group"     # Public Subnet EC2용 보안 그룹
  vpc_id = var.Jenkins_VPC_id                        # VPC 참조
  
  ## 인바운드 규칙
  # SSH 허용 (모든 IP)
  ingress {
    from_port   = 22              # 허용 시작 포트
    to_port     = 22              # 허용 끝 포트
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]  # bastion에서만 접속 가능
  }

  ## 아웃바운드 규칙
  # 모든 트래픽 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Daegok-Jenkins-SG"       
  }
}

#################################################################################
################################## ALB SG #######################################
#################################################################################

resource "aws_security_group" "ALB_sg" {
  name = "Daegok-ALB-SG"                            # SG 이름 (콘솔)
  description = "Public EC2 security group"     # Public Subnet EC2용 보안 그룹
  vpc_id = var.Service_VPC_id                       # VPC 참조
  
  ## 인바운드 규칙
  # SSH 허용 (모든 IP)
  ingress {
    from_port   = 80              # 허용 시작 포트
    to_port     = 80             # 허용 끝 포트
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH 허용 (모든 IP)
  ingress {
    from_port   = 443              # 허용 시작 포트
    to_port     = 443              # 허용 끝 포트
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ## 아웃바운드 규칙
  # 모든 트래픽 허용
  egress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    security_groups = [aws_security_group.jenkins_sg.id]
  }

  tags = {
    Name = "Daegok-ALB-SG"  
  }
}

#################################################################################
############################### Service SG ######################################
#################################################################################

resource "aws_security_group" "Service_sg" {
  name = "Daegok-Service-SG"                            # SG 이름 (콘솔)
  description = "Jenkins EC2 security group"     # Public Subnet EC2용 보안 그룹
  vpc_id = var.Service_VPC_id                    # VPC 참조
  
  ## 인바운드 규칙
  # SSH 허용 (모든 IP)
  ingress {
    from_port   = 8080              # 허용 시작 포트
    to_port     = 8080              # 허용 끝 포트
    protocol    = "tcp"
    security_groups = [aws_security_group.jenkins_sg.id]  # bastion에서만 접속 가능
  }

  ## 아웃바운드 규칙
  # 모든 트래픽 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Daegok-Service-SG"
  }
}
