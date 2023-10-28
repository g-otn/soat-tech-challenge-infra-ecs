provider "aws" {
  region  = "us-east-2"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_ecr_repository" "soat-tech-challenge-backend" {
  name = "registry.hub.docker.com/g0tn/soat-tech-challenge-backend"
}

resource "aws_instance" "ecs_host" {
  ami           = "ami-0fa399d9c130ec923"
  instance_type = "t2.micro"
  subnet_id = var.subnet_a_id
}

resource "aws_ecs_cluster" "soat-tech-challenge-ecs-cluster" {
  name = "soat-tech-challenge-ecs-cluster"
}

resource "aws_ecs_task_definition" "soat-tech-challenge-ecs-cluster-task" {
  family                   = "soat-tech-challenge-ecs-cluster-task-1"
  container_definitions    = <<DEFINITION
  [
    {
      "name": "soat-tech-challenge-ecs-cluster-task",
      "image": "${aws_ecr_repository.soat-tech-challenge-backend.repository_url}",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 8080,
          "hostPort": 8080
        }
      ],
      "memory": 512,
      "cpu": 256
    }
  ]
  DEFINITION
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
  memory                   = 512
  cpu                      = 256
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_alb" "soat-tech-challenge-alb" {
  name               = "soat-tech-challenge-alb-1" # Naming our load balancer
  load_balancer_type = "application"
  subnets = [ # Referencing the default subnets
    var.subnet_a_id,
    var.subnet_b_id
  ]
  # Referencing the security group
  security_groups = [aws_security_group.soat-tech-challenge-alb-security-group.id]
}

# Creating a security group for the load balancer:
resource "aws_security_group" "soat-tech-challenge-alb-security-group" {
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "soat-tech-challenge-alb-target-group" {
  name        = "soat-tech-challenge-alb-target"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id # Referencing the default VPC
}

resource "aws_lb_listener" "soat-tech-challenge-alb-listener" {
  load_balancer_arn = aws_alb.soat-tech-challenge-alb.arn # Referencing our load balancer
  port              = "8080"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.soat-tech-challenge-alb-target-group.arn # Referencing our tagrte group
  }
}

resource "aws_ecs_service" "soat-tech-challenge-service" {
  name            = "soat-tech-challenge-service-1"                             # Naming our first service
  cluster         = aws_ecs_cluster.soat-tech-challenge-ecs-cluster.id             # Referencing our created Cluster
  task_definition = aws_ecs_task_definition.soat-tech-challenge-ecs-cluster-task.arn # Referencing the task our service will spin up
  launch_type     = "EC2"
  desired_count   = 3

  load_balancer {
    target_group_arn = aws_lb_target_group.soat-tech-challenge-alb-target-group.arn # Referencing our target group
    container_name   = aws_ecs_task_definition.soat-tech-challenge-ecs-cluster-task.family
    container_port   = 3000 # Specifying the container port
  }

  network_configuration {
    subnets          = [
      var.subnet_a_id, var.subnet_b_id
    ]
    assign_public_ip = true                                                # Providing our containers with public IPs
    security_groups  = [aws_security_group.soat-tech-challenge-service-security-group.id] # Setting the security group
  }
}


resource "aws_security_group" "soat-tech-challenge-service-security-group" {
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    # Only allowing traffic in from the load balancer security group
    security_groups = [aws_security_group.soat-tech-challenge-alb-security-group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}