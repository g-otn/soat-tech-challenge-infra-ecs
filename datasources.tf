data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "tag:Name"
    values = ["soat-tech-challenge-subnet-public*"]
  }
}

data "aws_db_instance" "db_instance" {
  db_instance_identifier = "soat-tc-rds-db"
}
