output "ecs_cluster_name" {
  value = aws_ecs_cluster.soat_ecs_cluster.name
}

output "ecs_service_name" {
  value = aws_ecs_service.soat_ecs_service.name
}

output "load_balancer_dns_name" {
  value = aws_alb.soat_alb.dns_name
}

output "ecs_task_definition_arn" {
  value = aws_ecs_task_definition.soat_ecs_cluster_task.arn
}

output "ecs_task_execution_role_name" {
  value = aws_iam_role.soat_ecs_task_execution_role.name
}