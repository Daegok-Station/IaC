#################################################################################
########################## 기본 AWS 서비스 역할 정의 ###############################
#################################################################################

resource "aws_iam_role" "jenkins_agent_role" {
  name = "JenkinsAgentExecutionRole"
  # EC2 서비스가 이 역할을 맡을 수 있도록 허용 (AssumeRole Policy)
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# EC2 Instance Profile (EC2에 Role을 연결)
resource "aws_iam_instance_profile" "jenkins_instance_profile" {
  name = "jenkins-instance-profile"
  role = aws_iam_role.jenkins_agent_role.name
}

# ECS Task Execution Role (컨테이너 이미지 가져오기, 로그 기록 등)
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

# ECS Service Role (ECS : ALB, SG 관리)
resource "aws_iam_role" "ecs_service_role" {
  name = "ECSServiceRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ecs.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}


#################################################################################
######################### Jenkins Agent (EC2) 권한 ##############################
#################################################################################

resource "aws_iam_policy" "jenkins_s3_policy" {
  # 리소스 이름: aws_iam_policy.jenkins_s3_policy
  name = "JenkinsS3ArtifactPolicy-${var.artifact_bucket_name}"
  description = "Allows Jenkins Agent to upload artifacts (ZIP) to the dedicated S3 bucket."
  
  # 정책 내용은 ec2/variables.tf의 local.jenkins_s3_policy_document 변수를 참조
  policy = local.jenkins_s3_policy_document 
}

resource "aws_iam_policy" "jenkins_codepipeline_policy" {
  # 리소스 이름: aws_iam_policy.jenkins_codepipeline_policy
  name = "JenkinsCodePipelineTriggerPolicy"
  description = "Allows Jenkins Agent to trigger the CodePipeline execution."
  
  # 정책 내용은 ec2/variables.tf의 local.jenkins_codepipeline_policy_document 변수를 참조
  policy = local.jenkins_codepipeline_policy_document
}

# S3 업로드 정책을 Role에 연결
resource "aws_iam_role_policy_attachment" "jenkins_s3_attach" {
  policy_arn = aws_iam_policy.jenkins_s3_policy.arn
  role = aws_iam_role.jenkins_agent_role.name
}

# CodePipeline Trigger 정책을 Agent Role에 연결
resource "aws_iam_role_policy_attachment" "jenkins_codepipeline_trigger_attach" { 
  policy_arn = aws_iam_policy.jenkins_codepipeline_policy.arn
  role = aws_iam_role.jenkins_agent_role.name
}


#################################################################################
########################### CodePipeline 실행 권한 ###############################
#################################################################################

# CodePipeline이 S3 아티팩트 버킷에 접근
resource "aws_iam_policy" "codepipeline_s3_access_policy" {
  name        = "CodePipelineS3Access-${var.artifact_bucket_name}"
  description = "Allows CodePipeline to get/put artifacts from the dedicated S3 bucket."
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObject"
      ]
      Resource = [
        # S3 버킷 리소스 ARN을 참조해야 함 (aws_s3_bucket.pipeline_artifact는 다른 파일에 정의)
        var.artifact_bucket_arn,
        "${var.artifact_bucket_arn}/*"
      ]
    }]
  })
}

# CodePipeline이 사용할 IAM Role 생성
# (aws_iam_role.codepipeline_execution_role 참조 오류 해결)
resource "aws_iam_role" "codepipeline_execution_role" {
  name = "Daegok-CodePipeline-Role"
  # CodePipeline 서비스가 이 역할을 맡을 수 있도록 허용
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "codepipeline.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# CodeDeploy가 ECS 배포를 실행할 때 사용할 IAM Role 생성
# (aws_iam_role.codedeploy_service_role 참조 오류 해결)
resource "aws_iam_role" "codedeploy_service_role" {
  name = "Daegok-CodeDeploy-Role"
  # CodeDeploy 서비스가 이 역할을 맡을 수 있도록 허용
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "codedeploy.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# S3 접근 정책을 CodePipeline Role에 연결
resource "aws_iam_role_policy_attachment" "codepipeline_s3_attach_service" {
  policy_arn = aws_iam_policy.codepipeline_s3_access_policy.arn
  role = aws_iam_role.codepipeline_execution_role.name
}

# AWS 관리형 CodeDeploy 정책을 CodePipeline Role에 연결 (CodeDeploy 호출 권한)
resource "aws_iam_role_policy_attachment" "codepipeline_codedeploy_attach" {
  # AWSCodeDeployRole은 CodeDeploy 호출 권한을 제공합니다.
  policy_arn = "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess"
  role = aws_iam_role.codepipeline_execution_role.name
}

#################################################################################
######################### ECS 및 기타 사용자 정의 정책 #############################
#################################################################################

# ECS Service Role
resource "aws_iam_role_policy_attachment" "ecs_service_attach" {
  role = aws_iam_role.ecs_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

# ECS Task Execution Role
resource "aws_iam_role_policy_attachment" "task_execution_attach" {
  role = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "task_execution_s3_attach" {
  role = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# CodeDeploy Service Role에 필수 관리형 정책 연결
resource "aws_iam_role_policy_attachment" "codedeploy_service_attach" { # 이름 변경
  role = aws_iam_role.codedeploy_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

# ALB 정책
resource "aws_iam_policy" "alb_policy" {
  name = "ALB"
  policy = var.alb_policy_json
}

resource "aws_iam_role_policy_attachment" "alb_attach" {
  role = aws_iam_role.codedeploy_service_role.name
  policy_arn = aws_iam_policy.alb_policy.arn
}

# ECS_add_role (CodePipeline 관련)
resource "aws_iam_policy" "ecs_add_role_policy_pipeline" {
  name   = "ECS_add_role_pipeline"
  policy = var.ecs_add_role_policy_json
}

resource "aws_iam_role_policy_attachment" "ecs_add_role_attach_pipeline" {
  role = aws_iam_role.codepipeline_execution_role.name
  policy_arn = aws_iam_policy.ecs_add_role_policy_pipeline.arn
}

# Jenkins-ECS (CodePipeline 관련)
resource "aws_iam_policy" "jenkins_ecs_policy_pipeline" {
  name = "Jenkins-ECS-pipeline"
  policy = var.jenkins_ecs_policy_json
}

resource "aws_iam_role_policy_attachment" "jenkins_ecs_attach_pipeline" {
  role = aws_iam_role.codepipeline_execution_role.name
  policy_arn = aws_iam_policy.jenkins_ecs_policy_pipeline.arn
}
