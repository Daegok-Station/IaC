output "ecs_cluster_id" {
  value = aws_ecs_cluster.Daegok_ecs_cluster.id
  description = "ECS Cluster ID"
}

output "ecs_service_name" {
  value = aws_ecs_service.Daegok_ecs_service.name
  description = "ECS Service Name"
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.task_definition.arn
  description = "ECS Task Definition ARN"
}

# ecs/outputs.tf 파일에 추가
output "ecs_service_arn" {
  description = "The ARN of the ECS Service."
  value       = aws_ecs_service.Daegok_ecs_service.arn # 또는 .arn
}
