################################################################################

# EC2 Role & Instance Profile
resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_role"                     # Role과 동일
  role = aws_iam_role.ec2_role.name
}

# ECS Task Execution Role
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

# ECS Service Role
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

# CodeDeploy Role
resource "aws_iam_role" "codedeploy_role" {
  name = "Daegok-CodeDeploy-Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = [
          "codedeploy.amazonaws.com", 
          "codepipeline.amazonaws.com"
        ] }
      Action = "sts:AssumeRole"
    }]
  })
}

# CodePipeline Role
resource "aws_iam_role" "codepipeline_role" {
  name = "Daegok-CodePipeline-Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "codepipeline.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

################################################################################

# ECS Service Role
resource "aws_iam_role_policy_attachment" "ecs_service_attach" {
  role       = aws_iam_role.ecs_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

# ECS Task Execution Role
resource "aws_iam_role_policy_attachment" "task_execution_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "task_execution_s3_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "task_execution_logs_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

# CodeDeploy Role
resource "aws_iam_role_policy_attachment" "codedeploy_attach" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

# CodePipeline Role
resource "aws_iam_role_policy_attachment" "codepipeline_s3_attach" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "codepipeline_codedeploy_attach" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

# ECS Task Execution Role에 필수 정책 연결
resource "aws_iam_role_policy_attachment" "ecs_execution_policy_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name 
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

################################################################################

# ALB 정책
resource "aws_iam_policy" "alb_policy" {
  name   = "ALB"
  policy = var.alb_policy_json
}

resource "aws_iam_role_policy_attachment" "alb_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.alb_policy.arn
}

# ECS_add_role (CodePipeline 관련)
resource "aws_iam_policy" "ecs_add_role_policy_pipeline" {
  name   = "ECS_add_role_pipeline"
  policy = var.ecs_add_role_policy_json
}

resource "aws_iam_role_policy_attachment" "ecs_add_role_attach_pipeline" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.ecs_add_role_policy_pipeline.arn
}

# ECS_add_role (Task Execution 관련)
resource "aws_iam_policy" "ecs_add_role_policy_task" {
  name   = "ECS_add_role_task"
  policy = var.ecs_add_role_policy_json
}

resource "aws_iam_role_policy_attachment" "ecs_add_role_attach_task" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_add_role_policy_task.arn
}

# Jenkins-ECS (CodePipeline 관련)
resource "aws_iam_policy" "jenkins_ecs_policy_pipeline" {
  name   = "Jenkins-ECS-pipeline"
  policy = var.jenkins_ecs_policy_json
}

resource "aws_iam_role_policy_attachment" "jenkins_ecs_attach_pipeline" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.jenkins_ecs_policy_pipeline.arn
}

# Jenkins-ECS (Task Execution 관련)
resource "aws_iam_policy" "jenkins_ecs_policy_task" {
  name   = "Jenkins-ECS-task"
  policy = var.jenkins_ecs_policy_json
}

resource "aws_iam_role_policy_attachment" "jenkins_ecs_attach_task" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.jenkins_ecs_policy_task.arn
}

// (ec2/iam_role.tf 파일에 추가)

resource "aws_iam_policy" "codepipeline_artifacts_policy" {
  name        = "CodePipeline-Artifacts-Policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "s3:*", // 명시적으로 모든 S3 작업 허용
        Resource = [
          "arn:aws:s3:::daegok-pipeline-artifacts-489089",
          "arn:aws:s3:::daegok-pipeline-artifacts-489089/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codepipeline_artifacts_attach" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codepipeline_artifacts_policy.arn
}


# ec2/iam_role.tf

# 1. Jenkins Agent의 S3 권한 정책 생성
resource "aws_iam_policy" "jenkins_s3_policy" {
  name        = "JenkinsS3ArtifactPolicy-${var.artifact_bucket_name}"
  description = "Allows Jenkins to upload artifacts to the dedicated S3 bucket."
  
  # local에서 정의된 S3 정책 문서를 사용
  policy = local.jenkins_s3_policy_document 
}

# 2. Jenkins Agent의 CodePipeline 실행 권한 정책 생성
resource "aws_iam_policy" "jenkins_codepipeline_policy" {
  name        = "JenkinsCodePipelineTriggerPolicy"
  description = "Allows Jenkins to trigger the CodePipeline execution."
  
  # local에서 정의된 CodePipeline 정책 문서를 사용
  policy = local.jenkins_codepipeline_policy_document
}

# 3. Jenkins Agent가 사용할 IAM Role 생성
resource "aws_iam_role" "jenkins_agent_role" {
  name               = "JenkinsAgentExecutionRole"
  assume_role_policy = <<-EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# 4. S3 업로드 정책을 Role에 연결
resource "aws_iam_role_policy_attachment" "jenkins_s3_attach" {
  policy_arn = aws_iam_policy.jenkins_s3_policy.arn
  role       = aws_iam_role.jenkins_agent_role.name
}

# 5. CodePipeline 실행 정책을 Role에 연결
resource "aws_iam_role_policy_attachment" "jenkins_codepipeline_attach" {
  policy_arn = aws_iam_policy.jenkins_codepipeline_policy.arn
  role       = aws_iam_role.jenkins_agent_role.name
}

# 6. EC2 인스턴스 프로파일 생성 (EC2 인스턴스에 Role을 연결하기 위해 필요)
resource "aws_iam_instance_profile" "jenkins_instance_profile" {
  name = "jenkins-instance-profile"
  role = aws_iam_role.jenkins_agent_role.name
}

# 예시: CodePipeline Role에 연결할 정책 정의 (IAM Policy)
resource "aws_iam_policy" "codepipeline_s3_access_policy" {
  name = "CodePipelineS3Access"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketVersioning",
          "s3:PutObject" # CodePipeline이 중간 아티팩트를 버킷에 저장하기 위해 필요
        ]
        Resource = [
          aws_s3_bucket.pipeline_artifact.arn,
          "${aws_s3_bucket.pipeline_artifact.arn}/*"
        ]
      }
    ]
  })
}

# 💡 이 정책을 CodePipeline Role에 연결해야 합니다.
resource "aws_iam_role_policy_attachment" "codepipeline_s3_attach" {
  policy_arn = aws_iam_policy.codepipeline_s3_access_policy.arn
  role       = aws_iam_role.codepipeline_execution_role.name # CodePipeline Role 이름
}

# 예시: CodePipeline Role에 AWS 관리형 정책 연결 (ec2/iam_role.tf 또는 별도 파일)
resource "aws_iam_role_policy_attachment" "codepipeline_aws_managed_policy" {
  # CodePipeline의 기본 서비스 권한을 제공하는 AWS 관리형 정책
  policy_arn = "arn:aws:iam::aws:policy/AWSCodePipelineFullAccess"
  role       = aws_iam_role.codepipeline_execution_role.name # CodePipeline Role 이름
}

resource "aws_iam_role_policy_attachment" "codepipeline_code_deploy_managed_policy" {
  # CodeDeploy에 대한 접근 권한을 제공
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRole"
  role       = aws_iam_role.codepipeline_execution_role.name
}
