variable "order_svc_db_username" {
  description = "Order Service RDS Database instance master username"
  type        = string
}

variable "order_svc_db_password" {
  description = "Order Service RDS Database instance master password"
  type        = string
  sensitive   = true
}

variable "order_svc_db_name" {
  description = "Order Service RDS Database instance name"
  type        = string
  default     = "postgres"
}

// ---

variable "payment_svc_db_username" {
  description = "Payment Service RDS Database instance master username"
  type        = string
}

variable "payment_svc_db_password" {
  description = "Payment Service RDS Database instance master password"
  type        = string
  sensitive   = true
}

variable "payment_svc_db_name" {
  description = "Payment Service RDS Database instance name"
  type        = string
  default     = "postgres"
}
