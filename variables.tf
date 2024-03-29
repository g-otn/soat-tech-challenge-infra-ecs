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

variable "client_jwt_public_key" {
  description = "RSA256 Public Key used for verifying JWT"
  default     = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqStd8n4SGNM0eZhV/hzU+urHA5/IMZPoP9YQ9ZcLKWiX33nI6bSuZMCrLZcJExf63xS+uxDpGxM8Mnk2zOdl+lPwANXLzP1us5P1PyA3YPycW9J7C5YTQW0GiEL3M93ZX7vMJiVoBYblP3JPlYnoYlBORuc0JPk33KtfEZP+78qXpPHM8imYrJLe8ceiDLLFDU/nh5KC2dWAy3ci1ahoJ1Q9ELhp3IZLvOTX57H/T2VKOYOya5+ST41h+JjzI+qGTVnLcKaW+k25YLlVnkSspvdx98+yQDi7kbOTS6yRZHUPD6wPk/nUozpD0nZKccoH4W+zMwmQVtsAA6JCA9gfGwIDAQAB"
  type        = string
  sensitive   = true
}
