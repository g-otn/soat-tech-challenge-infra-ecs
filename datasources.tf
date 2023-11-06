data "aws_subnets" "private_subnets" {
  filter {
    name   = "tag:Name"
    values = ["soat-tech-challenge-subnet-public*"]
  }
}

data "aws_security_group" "sg_default" {
  name = "default"
}

data "aws_alb_target_group" "tg_alb" {
  name = "soat-alb-target-group"
}

data "aws_db_instance" "db_instance" {
  db_instance_identifier = "soat-tc-rds-db"
}
