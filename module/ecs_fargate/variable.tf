variable "cluster_name" {}
variable "task_family" {}
variable "cpu" {}
variable "memory" {}
variable "execution_role_arn" {}
variable "task_role_arn" {}
variable "container_name" {}
variable "container_image" {}
variable "container_port" {}
variable "service_name" {}
variable "desired_count" {}
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