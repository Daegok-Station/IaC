#################################################################################
################################ ECS Task Definition ############################
#################################################################################

resource "aws_ecs_task_definition" "task_definition" {
  family = "Daegok-Petclinic-task"
  network_mode = "awsvpc"   # Fargate 실행을 위한 네트워크 모드 awsvpc
  requires_compatibilities = ["FARGATE"]
  cpu    = "256"
  memory = "512"
  execution_role_arn = "arn:aws:iam::954382416992:role/ecsTaskExecutionRole" # iam rope arn

  # 컨테이너 정의
  container_definitions = <<TASK_DEFINITION
[
  {
    "cpu": 0,
    "essential": true,
    "image": "${aws_ecr_repository.ecr.repository_url}:latest",  # Jenkins push 이미지 자동 참조
    "name": "web",
    "portMappings": [
      {
        "containerPort": 8080,
        "hostPort": 8080,
        "protocol": "tcp"
      }
    ],
    "environment": [
      {
        "name": "ENVIRONMENT",
        "value": "dev"                      
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/Daegok-Petclinic-task",  
        "awslogs-create-group": "true",
        "awslogs-region": "ap-northeast-2",         
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
TASK_DEFINITION
}
