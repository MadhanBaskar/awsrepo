variable "cluster_name" {
  description = "ECS Cluster name"
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

variable "subnet_ids" {
  description = "List of subnet IDs for ECS services"
  type        = list(string)
}

variable "services" {
  description = "List of ECS services with their own container/task settings"
  type = list(object({
    name             = string
    desired_count    = number
    security_groups  = list(string)
    assign_public_ip = bool
    container_name   = string
    container_image  = string
    container_port   = number
    cpu              = number
    memory           = number
    load_balancer = optional(object({
      target_group_arn = string
    }))
  }))
}