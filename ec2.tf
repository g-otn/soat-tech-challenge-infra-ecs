resource "aws_launch_template" "soat_lauch_template" {
  name_prefix   = "soat_lauch_template"
  image_id      = "ami-0fa399d9c130ec923"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.soat_ecs_security_group.id]

  iam_instance_profile {
    name = "ecsInstanceRole"
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ecs-instance"
    }
  }
}

resource "aws_autoscaling_group" "soat_autoscaling_group" {
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
  vpc_zone_identifier = data.aws_subnets.private_subnets.ids

  launch_template {
    id      = aws_launch_template.soat_lauch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}