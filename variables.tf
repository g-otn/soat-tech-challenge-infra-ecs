// Variable sets

variable "aws_region" {
  description = "AWS Region to create resources on"
  type        = string
  default     = "us-east-1"
}

variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
  sensitive   = true
}

variable "aws_session_token" {
  description = "AWS Session Token"
  type        = string
  sensitive   = true
}
