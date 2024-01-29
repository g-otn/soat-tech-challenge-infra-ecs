resource "aws_ecs_cluster" "main" {
  name = "SOAT_Tech_Challenge_ECS_Cluster"
}

// TODO: move to module and use file()

resource "aws_ecs_task_definition" "order_svc_td" {
  family             = "SOAT_TC_ECS_Order_Service_Family"
  network_mode       = "awsvpc"
  task_role_arn      = data.aws_iam_role.lab_role.arn
  execution_role_arn = data.aws_iam_role.lab_role.arn
  // https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html
  cpu                      = 512
  memory                   = 1024
  requires_compatibilities = ["FARGATE"]
  container_definitions = jsonencode(
    [
      {
        name : "SOAT-TC_ECS_Order_SVC_Main_Container",
        image : "registry.hub.docker.com/g0tn/soat-tech-challenge-service-order",
        cpu : 512,
        memory : 1024,
        essential : true,
        portMappings : [
          {
            containerPort : 8002,
            hostPort : 8002
          }
        ],
        environment : [
          {
            name : "DB_USERNAME",
            value : var.order_svc_db_username
          },
          {
            name : "DB_PASSWORD",
            value : var.order_svc_db_password
          },
          {
            name : "DB_NAME",
            value : var.order_svc_db_name
          },
          {
            name : "DB_HOST",
            value : data.tfe_outputs.database.values.order_svc_db.endpoint
          },
          {
            name : "JWT_PUBLIC_KEY",
            value : var.client_jwt_public_key
          },
          {
            name : "API_URL_IDENTIFICATION",
            value : "${data.tfe_outputs.network.values.lb_lb.dns_name}"
          }
        ]
        logConfiguration : {
          logDriver : "awslogs",
          options : {
            awslogs-create-group : "true",
            awslogs-group : "/aws/ecs/order-svc",
            awslogs-region : var.aws_region,
            awslogs-stream-prefix : "order-svc"
          }
        },
      }
  ])

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  tags = {
    Name : "SOAT-TC ECS Order Service ECS Service Family"
  }
}

resource "aws_ecs_service" "order_svc" {
  name                              = "SOAT_TC_ECS_Order_Service"
  cluster                           = aws_ecs_cluster.main.id
  task_definition                   = aws_ecs_task_definition.order_svc_td.arn
  desired_count                     = 1
  launch_type                       = "FARGATE"
  scheduling_strategy               = "REPLICA"
  force_new_deployment              = true
  health_check_grace_period_seconds = 300

  network_configuration {
    assign_public_ip = true
    subnets          = data.tfe_outputs.network.values.vpc_public_subnets[*].id
    security_groups  = [data.tfe_outputs.network.values.vpc_vpc.default_security_group_id]
  }

  load_balancer {
    container_name   = "SOAT-TC_ECS_Order_SVC_Main_Container"
    container_port   = 8002
    target_group_arn = data.tfe_outputs.network.values.lb_tgs.ecs_order_svc_tg.arn
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = false
  }

  tags = {
    Name : "SOAT-TC Order Service ECS Service"
  }
}

// -----
