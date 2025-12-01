#################################################################################
################################ ecs_service ####################################
#################################################################################

resource "aws_ecs_service" "Daegok_ecs_service" {
  name = "Daegok-Cluster-Service"
  cluster = aws_ecs_cluster.Daegok_ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count = 2         # 동시에 유지할 Task 개수

  launch_type = "FARGATE"       # 서비스 실행 유형 (Fargate)
  platform_version = "LATEST"   # fargate 플랫폼 버전 (default)
  scheduling_strategy = "REPLICA"   # 스케줄링 전략 (default)

  deployment_controller {   # CodeDeploy : Blue/Green 배포 허용
    type = "CODE_DEPLOY"
  }

  network_configuration {   # Fargate -> VPC 네트워크 설정 필수
    subnets = [var.private_subnet_id_01]
    assign_public_ip = false    # 퍼블릭 IP 할당 금지
  }

  # CodeDeploy Blue/Green에서 BLUE 타겟 그룹을 ECS 서비스에 연결
  load_balancer {
    target_group_arn = var.blue_tg_arn
    container_name   = "web"
    container_port   = 8080
  }

  # load balancer 연결 (green 타겟 그룹, 동일한 설정이지만 target_group만 다름)
  load_balancer {
    target_group_arn = var.green_tg_arn
    container_name   = "web"
    container_port   = 8080
  }

  health_check_grace_period_seconds = 60    # 컨테이너 뜨고 헬스체크 통과 기다리는 시간

  # 서비스에서 태그를 상속받도록 설정 (리소스 관리 편함)
  propagate_tags = "SERVICE"
}
