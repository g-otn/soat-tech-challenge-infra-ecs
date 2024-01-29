variable "container_definitions" {
  description = "JSON-encoded array of container definitions for a ECS Task Definition"
  sensitive   = true
}

variable "task_role_arn" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

variable "ecs_cluster_id" {
  type = string
}
