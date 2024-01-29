variable "subnet_ids" {
  type = list(string)
}

variable "security_groups_ids" {
  type = list(string)
}


variable "lb_target_group_arn" {
  type = string
}

variable "lb_container_port" {
  type = number
}
