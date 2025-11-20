#################################################################################
################################### EC2 ID ######################################
#################################################################################

output "ec2_bastion_id" {
    value = aws_instance.ec2_bastion.id
    description = "ID of the Bastion EC2 Instance"
}

output "ec2_jenkins_id" {
    value = aws_instance.ec2_jenkins.id
    description = "ID of the Jenkins EC2 Instance"
}

#################################################################################
############################## Bastion EC2 IP ###################################
#################################################################################

output "ec2_bastion_ip" {
    value = aws_instance.ec2_bastion.public_ip
    description = "Public IP of the Bastion EC2 Insatnace"
}
