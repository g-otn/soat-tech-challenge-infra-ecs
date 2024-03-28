resource "aws_ecs_task_definition" "this" {
  family             = "SOAT_TC_ECS_${var.id}_Service_Family"
  network_mode       = "awsvpc"
  task_role_arn      = var.task_role_arn
  execution_role_arn = var.execution_role_arn
  // https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html
  cpu                      = 512
  memory                   = 1024
  requires_compatibilities = ["FARGATE"]
  container_definitions    = var.container_definitions

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  tags = {
    Name : "SOAT-TC ECS ${var.name} Service ECS Service Family"
  }
}

resource "aws_ecs_service" "this" {
  name                              = "SOAT_TC_ECS_${var.id}_Service"
  cluster                           = var.ecs_cluster_id
  task_definition                   = aws_ecs_task_definition.this.arn
  desired_count                     = 1
  launch_type                       = "FARGATE"
  scheduling_strategy               = "REPLICA"
  force_new_deployment              = true
  health_check_grace_period_seconds = 180

  network_configuration {
    assign_public_ip = true
    subnets          = var.subnet_ids
    security_groups  = var.security_groups_ids
  }

  load_balancer {
    container_name   = "SOAT-TC_ECS_${var.id}_SVC_Main_Container"
    container_port   = var.lb_container_port
    target_group_arn = var.lb_target_group_arn
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = false
  }

  tags = {
    Name : "SOAT-TC ${var.name} Service ECS Service"
  }
}
