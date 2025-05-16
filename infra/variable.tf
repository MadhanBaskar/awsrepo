variable "region" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

variable "task_role_arn" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "security_groups" {
  type = list(string)
}

variable "assign_public_ip" {
  type    = bool
  default = true
}

# App 1 variables
variable "app1_task_family" {
  type = string
}
variable "app1_cpu" {
  type = string
}
variable "app1_memory" {
  type = string
}
variable "app1_container_name" {
  type = string
}
variable "app1_container_image" {
  type = string
}
variable "app1_container_port" {
  type = number
}
variable "app1_service_name" {
  type = string
}
variable "app1_desired_count" {
  type = number
}

# App 2 variables
variable "app2_task_family" {
  type = string
}
variable "app2_cpu" {
  type = string
}
variable "app2_memory" {
  type = string
}
variable "app2_container_name" {
  type = string
}
variable "app2_container_image" {
  type = string
}
variable "app2_container_port" {
  type = number
}
variable "app2_service_name" {
  type = string
}
variable "app2_desired_count" {
  type = number
}