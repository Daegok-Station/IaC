#################################################################################
################################### EC2 ID ######################################
#################################################################################

output "ec2_bastion_id" {
    value = aws_instance.ec2_bastion.id
    description = "Bastion EC2 Instance ID"
}

output "ec2_jenkins_id" {
    value = aws_instance.ec2_jenkins.id
    description = "Jenkins EC2 Instanc ID"
}

#################################################################################
############################## Bastion EC2 IP ###################################
#################################################################################

output "ec2_bastion_ip" {
    value = aws_instance.ec2_bastion.public_ip
    description = "Bastion EC2 Insatnace Public IP"
}



output "codedeploy_role_arn" {
  value  = aws_iam_role.codedeploy_role.arn
  description = "CodeDeploy Role ARN"
}

#################################################################################
############################# IAM Role & SG IDs #################################
#################################################################################

#ECS Task Execution Role ARN (ECS Task Definition에서 사용)
output "ecs_task_execution_role_arn" {
    value       = aws_iam_role.ecs_task_execution_role.arn
    description = "ARN for the ECS Task Execution Role."
}

#ECS Service Role ARN (ECS Service 생성 시 사용)
output "ecs_service_role_arn" {
    value       = aws_iam_role.ecs_service_role.arn
    description = "ARN for the ECS Service Role."
}

# CodePipeline Role ARN (CodePipeline 파이프라인 생성 시 사용)
output "codepipeline_role_arn" {
    value       = aws_iam_role.codepipeline_role.arn
    description = "ARN for the CodePipeline Service Role."
}

# EC2 인스턴스 프로파일 이름 (EC2 인스턴스에 연결)
output "ec2_instance_profile_name" {
    value       = aws_iam_instance_profile.ec2_profile.name
    description = "Name of the EC2 Instance Profile."
}

output "bastion_sg_id" {
    value = aws_security_group.bastion_sg.id
    description = "Security Group ID for Bastion Host"
}

output "jenkins_sg_id" {
    value = aws_security_group.jenkins_sg.id
    description = "Security Group ID for Jenkins Host"
}
