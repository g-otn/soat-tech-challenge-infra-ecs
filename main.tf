resource "aws_ecr_repository" "soat_backend_image" {
  name = "registry.hub.docker.com/g0tn/soat-tech-challenge-backend"
}

resource "aws_launch_template" "soat_lauch_template" {
  name_prefix   = "soat_lauch_template"
  image_id      = "ami-0fa399d9c130ec923"
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "soat_autoscaling_group" {
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
  health_check_type   = "EC2"
  vpc_zone_identifier = [var.subnet_a_id, var.subnet_b_id]

  launch_template {
    id      = aws_launch_template.soat_lauch_template.id
    version = "$Latest"
  }
}

resource "aws_ecs_capacity_provider" "soat_ecs_capacity_provider" {
  name = "soat_ecs_capacity_provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.soat_autoscaling_group.arn
  }
}

resource "aws_ecs_cluster" "soat_ecs_cluster" {
  name = "soat-tech-challenge-ecs-cluster"
}

data "aws_db_instance" "db_instance" {
  db_instance_identifier = "soat-tc-rds-db"
}

resource "aws_ecs_task_definition" "soat_ecs_cluster_task" {
  family = "soat-ecs-cluster-task"

  container_definitions = jsonencode(
    [
      {
        name : "soat-ecs-cluster-task",
        image : aws_ecr_repository.soat_backend_image.repository_url,
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
        memory : 512,
        cpu : 256,
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
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
  memory                   = 512
  cpu                      = 256
  task_role_arn            = aws_iam_role.soat_ecs_task_execution_role.arn
  execution_role_arn       = aws_iam_role.soat_ecs_task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
}

resource "aws_ecs_service" "soat_ecs_service" {
  name            = "soat-ecs-service"
  cluster         = aws_ecs_cluster.soat_ecs_cluster.id
  task_definition = aws_ecs_task_definition.soat_ecs_cluster_task.arn
  launch_type     = "EC2"
  desired_count   = 1

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.soat_ecs_capacity_provider.name
    weight            = 1
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.soat_alb_target_group.arn
    container_name   = "soat-ecs-cluster-task"
    container_port   = var.port
  }

  network_configuration {
    subnets = [
      var.subnet_a_id,
      var.subnet_b_id
    ]
    security_groups = [aws_security_group.soat_ecs_security_group.id]
  }
}

resource "aws_security_group" "soat_ecs_security_group" {
  vpc_id = var.vpc_id
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.soat_alb_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

