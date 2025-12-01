#################################################################################
############################# AWS Public Key pair ###############################
#################################################################################

data "aws_key_pair" "bastion_key" {
  key_name = var.bastion_key_name
}

data "aws_key_pair" "jenkins_key" {
  key_name = var.jenkins_key_name
}
