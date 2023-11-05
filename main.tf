resource "aws_ecr_repository" "soat_backend_image" {
  name = "registry.hub.docker.com/g0tn/soat-tech-challenge-backend"
}

resource "aws_ecs_cluster" "soat_ecs_cluster" {
  name = "soat-tech-challenge-ecs-cluster"
}

resource "aws_ecs_capacity_provider" "soat_ecs_capacity_provider" {
  name = "soat_ecs_capacity_provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.soat_autoscaling_group.arn

    managed_scaling {
      maximum_scaling_step_size = 1000
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 1
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "soat_ecs_cluster_capacity_providers" {
  cluster_name = aws_ecs_cluster.soat_ecs_cluster.name

  capacity_providers = [aws_ecs_capacity_provider.soat_ecs_capacity_provider.name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.soat_ecs_capacity_provider.name
  }
}

resource "aws_ecs_task_definition" "soat_ecs_cluster_task" {
  family                   = "soat-ecs-cluster-task"
  network_mode             = "awsvpc"
  task_role_arn            = "arn:aws:iam::381717072124:role/ecsTaskExecutionRole"
  execution_role_arn       = "arn:aws:iam::381717072124:role/ecsTaskExecutionRole"
  cpu                      = 256
  memory                   = 512
  container_definitions = jsonencode(
    [
      {
        name : "soat-ecs-cluster-task",
        image : aws_ecr_repository.soat_backend_image.repository_url,
        cpu : 256,
        memory : 512,
        essential : true,
        portMappings : [
          {
            containerPort : 8080,
            hostPort : 8080
          }
        ],
        environment : [
          {
            name : "DB_USERNAME",
            value : var.ecs_container_db_username
          },
          {
            name : "DB_PASSWORD",
            value : var.ecs_container_db_password
          },
          {
            name : "DB_NAME",
            value : var.ecs_container_db_name
          },
          {
            name : "DB_HOST",
            value : data.aws_db_instance.db_instance.endpoint
          }
        ]
        logConfiguration : {
          logDriver : "awslogs",
          options : {
            awslogs-create-group : "true",
            awslogs-group : "awslogs-backend",
            awslogs-region : "us-east-2",
            awslogs-stream-prefix : "awslogs-backend"
          }
        },
      }
    ])

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
}

resource "aws_ecs_service" "soat_ecs_service" {
  name            = "soat-ecs-service"
  cluster         = aws_ecs_cluster.soat_ecs_cluster.id
  task_definition = aws_ecs_task_definition.soat_ecs_cluster_task.arn
  desired_count   = 1

  network_configuration {
    subnets = data.aws_subnets.private_subnets.ids
    security_groups = [aws_security_group.soat_ecs_security_group.id]
  }

  force_new_deployment = true
  placement_constraints {
    type = "distinctInstance"
  }

  triggers = {
    redeployment = timestamp()
  }

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.soat_ecs_capacity_provider.name
    weight            = 100
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.soat_alb_target_group.arn
    container_name   = "soat-ecs-cluster-task"
    container_port   = var.port
  }

  depends_on = [aws_autoscaling_group.soat_autoscaling_group]
}


