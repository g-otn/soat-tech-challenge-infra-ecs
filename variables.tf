variable "aws_region" {
  description = "Região AWS onde criar a instância RDS"
  type        = string
  default     = "us-east-2"
}

variable "port" {
  description = "Port"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_a_id" {
  description = "SUBNET A ID"
  type        = string
}

variable "subnet_b_id" {
  description = "SUBNET B ID"
  type        = string
}

variable "ecs_container_db_username" {
  default = "backend"
  type    = string
}

variable "ecs_container_db_password" {
  default = "backend"
  type    = string
}

variable "ecs_container_db_name" {
  default = "tech_challenge"
  type    = string
}

variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
}
