resource "aws_ecs_cluster" "this" {
  name = "soat-tech-challenge-ecs-cluster"
}

resource "aws_ecs_task_definition" "this" {
  family                   = "soat-ecs-cluster-task"
  network_mode             = "awsvpc"
  task_role_arn            = "arn:aws:iam::381717072124:role/ecsTaskExecutionRole"
  execution_role_arn       = "arn:aws:iam::381717072124:role/ecsTaskExecutionRole"
  cpu                      = 256
  memory                   = 512
  requires_compatibilities = ["FARGATE"]
  container_definitions    = jsonencode(
    [
      {
        name : "soat-ecs-cluster-task",
        image : "registry.hub.docker.com/g0tn/soat-tech-challenge-backend",
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
          },
          {
            name : "JWT_PUBLIC_KEY",
            value : var.ecs_container_jwt_public_key
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

resource "aws_ecs_service" "this" {
  name                 = "soat-ecs-service"
  cluster              = aws_ecs_cluster.this.id
  task_definition      = aws_ecs_task_definition.this.arn
  desired_count        = 1
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  force_new_deployment = true
  health_check_grace_period_seconds = 600

  network_configuration {
    assign_public_ip = true
    subnets          = data.aws_subnets.private_subnets.ids
    security_groups  = [data.aws_security_group.sg_default.id]
  }

  load_balancer {
    container_name   = "soat-ecs-cluster-task"
    container_port   = var.port
    target_group_arn = data.aws_alb_target_group.tg_alb.arn
  }
}
