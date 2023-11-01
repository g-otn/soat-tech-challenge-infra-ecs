resource "aws_alb" "soat_alb" {
  name               = "soat-alb"
  load_balancer_type = "application"
  subnets            = [
    var.subnet_a_id,
    var.subnet_b_id
  ]
  security_groups = [aws_security_group.soat_alb_security_group.id]
}

resource "aws_security_group" "soat_alb_security_group" {

  vpc_id = var.vpc_id

  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_listener" "soat_alb_listener" {
  load_balancer_arn = aws_alb.soat_alb.arn
  port              = var.port
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.soat_alb_target_group.arn
  }
}

resource "aws_lb_target_group" "soat_alb_target_group" {
  name        = "soat-alb-target-group"
  port        = var.port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}