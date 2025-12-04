# CodeDeploy 앱 생성
resource "aws_codedeploy_app" "Daegok-CodeDeploy" {
    name = "Daegok-CodeDeploy"
    compute_platform = "ECS"
}

# CodeDeploy 배포 그룹 생성
resource "aws_codedeploy_deployment_group" "ecs_deployment_group" {
    app_name = "Daegok-CodeDeploy"
    deployment_group_name = "Daegok-CodeDeploy"
    service_role_arn = var.codedeploy_role_arn

    deployment_config_name = "CodeDeployDefault.ECSLinear10PercentEvery1Minutes" # 옵션: Canary, Linear 등
    auto_rollback_configuration {
        enabled = true               # 자동 롤백 활성화
        events  = ["DEPLOYMENT_FAILURE"]  # 배포 실패 시 롤백
    }

    depends_on = [
      var.ecs_service_arn
    ]

    # 배포 성공 시 기존 BLUE Task 어떻게 할지
    blue_green_deployment_config {
        terminate_blue_instances_on_deployment_success {
        action = "TERMINATE"
        termination_wait_time_in_minutes = 5
        }

        deployment_ready_option {
        action_on_timeout = "CONTINUE_DEPLOYMENT"
        wait_time_in_minutes = 0
        }
    }

  deployment_style {
        deployment_type   = "BLUE_GREEN"
        deployment_option = "WITH_TRAFFIC_CONTROL"
    }

  ecs_service {
    cluster_name = "Daegok-Cluster"
    service_name = "Daegok-Cluster-Service"
  }

  load_balancer_info {
    target_group_pair_info {
      target_group {
        name = "Daegok-blue"
      }
      target_group {
        name = "Daegok-green"
      }
      prod_traffic_route {
        listener_arns = [
          var.blue_listener_arn
        ]
      }
      }
    }
  }
