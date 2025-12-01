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

resource "aws_iam_role_policy_attachment" "codepipeline_s3_readonly_attach" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "codepipeline_codedeploy_attach" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
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

