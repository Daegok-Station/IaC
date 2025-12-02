resource "aws_lb" "Daegok_alb" {
  name = "Daegok-ALB"
  internal = false      # 퍼블릭 ALB
  load_balancer_type = "application"    # 로드 밸런서 유형
  security_groups = [aws_security_group.alb_sg.id]

  subnets = [
    var.public_subnet_id_01,
    var.public_subnet_id_02
  ]

  # enable_deletion_protection = true
}

#################################################################################
################################## ALB SG #######################################
#################################################################################

resource "aws_security_group" "alb_sg" {
  name = "Daegok-ALB-SG"                        # SG 이름 (콘솔)
  description = "Public EC2 security group"     # Public Subnet EC2용 보안 그룹
  vpc_id = var.Service_VPC_id                   # VPC 참조
  
  ## 인바운드 규칙
  # SSH 허용 (모든 IP)
  ingress {
    from_port   = 80              # 허용 시작 포트
    to_port     = 80             # 허용 끝 포트
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS 허용
  ingress {
    from_port   = 443              # 허용 시작 포트
    to_port     = 443              # 허용 끝 포트
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ## 아웃바운드 규칙
  # 모든 트래픽 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.Service_VPC_cidr]
  }

  tags = {
    Name = "Daegok-ALB-SG"  
  }
}
