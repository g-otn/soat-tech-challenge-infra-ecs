variable "aws_region" {
  description = "Região AWS onde criar a instância RDS"
  type        = string
  default     = "us-east-2"
}

variable "port" {
  description = "Port"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "subnet_a_id" {
  description = "SUBNET A ID"
}

variable "subnet_b_id" {
  description = "SUBNET B ID"
}

variable "aws_access_key" {
  description = "AWS Access Key"
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
}
