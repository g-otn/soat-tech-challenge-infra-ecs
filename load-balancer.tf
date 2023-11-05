resource "aws_alb" "soat_alb" {
  name               = "soat-alb"
  subnets            = data.aws_subnets.private_subnets.ids
  security_groups = [aws_security_group.soat_alb_security_group.id]

  tags = {
    Name = "ecs-alb"
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
  vpc_id      = data.aws_vpc.vpc.id
}
