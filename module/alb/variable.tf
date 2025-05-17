# modules/alb/variables.tf

variable "name_prefix" {
  description = "Prefix to use for naming resources"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs to place the ALB in"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for the ALB"
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "internal" {
  description = "If true, the ALB will be internal"
  type        = bool
  default     = false
}

variable "enable_deletion_protection" {
  description = "If true, deletion of the ALB will be disabled"
  type        = bool
  default     = false
}

variable "drop_invalid_header_fields" {
  description = "Indicates whether HTTP headers with header fields that are not valid are removed by the load balancer"
  type        = bool
  default     = false
}

variable "idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle"
  type        = number
  default     = 60
}

variable "http_port" {
  description = "Port for HTTP listeners"
  type        = number
  default     = 80
}

variable "https_port" {
  description = "Port for HTTPS listeners"
  type        = number
  default     = 443
}

variable "target_groups" {
  description = "Map of target group configurations"
  type        = map(any)
}

variable "default_target_group_key" {
  description = "Key of the default target group"
  type        = string
}

variable "target_group_attachments" {
  description = "List of target group attachment configurations"
  type        = list(any)
  default     = []
}

variable "path_based_rules" {
  description = "Map of path-based routing rules"
  type        = map(any)
  default     = {}
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate for HTTPS listener"
  type        = string
  default     = null
}

variable "ssl_policy" {
  description = "SSL policy for HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
}

variable "access_logs_bucket" {
  description = "S3 bucket name for ALB access logs"
  type        = string
  default     = null
}

variable "access_logs_prefix" {
  description = "S3 bucket prefix for ALB access logs"
  type        = string
  default     = "alb-logs"
}
variable "additional_listeners" {
  description = "Map of additional listeners to create"
  type = map(object({
    port            = number
    protocol        = string
    target_group_key = string
  }))
  default = {}
}

variable "additional_listener_rules" {
  description = "Map of rules for additional listeners"
  type = map(object({
    listener_key     = string
    priority         = number
    path_patterns    = list(string)
    target_group_key = string
  }))
  default = {}
}