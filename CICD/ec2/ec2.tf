#################################################################################
########################## Jenkins ec2 instance #################################
#################################################################################

resource "aws_instance" "ec2_bastion" {
  ami = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"  # Amazon Linux 2023 최신 AMI
  instance_type = "t3.micro"                                    # 인스턴스 유형
  subnet_id = var.bastion_subnet_id                             # Public Subnet 연결
  key_name = aws_key_pair.Daegok_Bastion_pub.key_name           # Bastion Key Pair
  associate_public_ip_address = true                            # 퍼블릭 IP 자동 할당
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]   # Bastion SG 연결

  root_block_device {
    volume_size = 8       # 8 GiB
    volume_type = "gp3"   # gp3 유형
  }

  tags = {
    Name = "Daegok-public-Jenkins"
  }
}

resource "aws_instance" "ec2_jenkins" {
  ami = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"  # Amazon Linux 2023 최신 AM
  instance_type = "t3.micro"                                   # 인스턴스 유형
  subnet_id = var.jenkins_subnet_id                            # Private Subnet 연결
  key_name = aws_key_pair.Daegok_Jenkins_pub.key_name          # Jenkins Key Pair 
  associate_public_ip_address = false                          # 퍼블릭 IP 자동 할당 비활성
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]  # 기존 Public SG 사용

  root_block_device {
    volume_size = 8       # 8 GiB
    volume_type = "gp3"   # gp3 유형
  }

  # User Data 별도 파일에서 불러오기
  user_data = templatefile("${path.module}/user_data/jenkins_userdata.tpl", {})

  tags = {
    Name = "Daegok-private-Jenkins"
  }
}
