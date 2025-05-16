variable "cluster_name" {
  description = "ECS Cluster name"
  type        = string
}

variable "task_family" {
  description = "Task definition family"
  type        = string
}

variable "cpu" {
  description = "CPU units for the task"
  type        = string
}

variable "memory" {
  description = "Memory for the task"
  type        = string
}

variable "execution_role_arn" {
  description = "Execution role ARN"
  type        = string
}

variable "task_role_arn" {
  description = "Task role ARN"
  type        = string
}

variable "container_name" {
  description = "Container name"
  type        = string
}

variable "container_image" {
  description = "Container image"
  type        = string
}

variable "container_port" {
  description = "Container port"
  type        = number
}

variable "subnet_ids" {
  description = "List of subnet IDs for ECS services"
  type        = list(string)
}

variable "services" {
  description = "List of ECS services"
  type = list(object({
    name             = string
    desired_count    = number
    security_groups  = list(string)
    assign_public_ip = bool
    load_balancer = optional(object({
      target_group_arn = string
    }))
  }))
}