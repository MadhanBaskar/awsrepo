variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "create_nat_gateway" {
  description = "Whether to create a NAT Gateway"
  type        = bool
}
variable "name" {
  description = "VPC name"
  type        = string
}
#############################
variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
}

variable "role_name" {
  description = "Name of the IAM role for EKS"
  type        = string
}

#variable "vpc_subnets" {
#  description = "List of VPC subnet IDs"
#  type        = list(string)
#}

variable "node_group_name" {
  description = "The name of the node group"
  type        = string
}

variable "node_instance_type" {
  description = "EC2 instance type for the node group"
  type        = list(string)
}

variable "node_disk_size" {
  description = "Disk size for the node group instances"
  type        = number
}

variable "policy_arns" {
  description = "List of IAM policy ARNs to attach to the roles"
  type        = list(string)
}

variable "eks_addons" {
  description = "Map of EKS addons and their versions"
  type        = map(string)
}

variable "principal_arn" {
  description = "The ARN of the principal for access entry"
  type        = string
}

variable "kubernetes_groups" {
  description = "Kubernetes groups for access entry"
  type        = list(string)
}

variable "access_policy_arn" {
  description = "The ARN of the access policy"
  type        = string
}

#variable "vpc_id" {
#  description = "ID of the VPC where the EKS cluster will be deployed"
#  type        = string
#}

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