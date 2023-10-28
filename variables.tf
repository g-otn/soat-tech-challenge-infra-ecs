variable "aws_access_key" {
  description = "AWS Access Key"
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
}

variable "vpc_id" {
  description = "VPC ID"
  type = string
  default = "education"
}

variable "subnet_a_id" {
  description = "SUBNET A ID"
  type = string
  default = "education-public-us-east-2a"
}

variable "subnet_b_id" {
  description = "SUBNET B ID"
  type = string
  default = "education-public-us-east-2b"
}
