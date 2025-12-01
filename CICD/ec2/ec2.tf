#################################################################################
########################## Jenkins ec2 instance #################################
#################################################################################

resource "aws_instance" "ec2_bastion" {
   ami           = data.aws_ssm_parameter.latest_al2023_ami.value
  instance_type = "t3.micro"                                    # 인스턴스 유형
  subnet_id = var.bastion_subnet_id                             # Public Subnet 연결
  key_name = data.aws_key_pair.bastion_key.key_name             # Bastion Key Pair
  associate_public_ip_address = true                            # 퍼블릭 IP 자동 할당
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]   # Bastion SG 연결

  root_block_device {
    volume_size = 8      
    volume_type = "gp3"   
  }

  tags = {
    Name = "Daegok-public-Jenkins"
  }
}

resource "aws_instance" "ec2_jenkins" {
   ami           = data.aws_ssm_parameter.latest_al2023_ami.value
  instance_type = "t3.micro"                                    # 인스턴스 유형
  subnet_id = var.jenkins_subnet_id                             # Private Subnet 연결
  key_name = data.aws_key_pair.jenkins_key.key_name             # Jenkins Key Pair 
  associate_public_ip_address = false                           # 퍼블릭 IP 자동 할당 비활성
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]   # 기존 Public SG 사용

  root_block_device {
    volume_size = 8       
    volume_type = "gp3" 
  }

  user_data = templatefile("${path.module}/user_data/jenkins_userdata.tpl", {})

  tags = {
    Name = "Daegok-private-Jenkins"
  }
}

data "aws_ssm_parameter" "latest_al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}
