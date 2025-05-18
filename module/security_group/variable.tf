# modules/security_groups/variables.tf

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the cluster is deployed"
  type        = string
}

variable "api_access_cidrs" {
  description = "List of CIDR blocks that can access the EKS API server"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "lb_ingress_cidrs" {
  description = "List of CIDR blocks that can access load balancers"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}