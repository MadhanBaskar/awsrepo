variable "name" {
  description = "Name of the IAM role"
  type        = string
}

variable "trust_policy_json" {
  description = "Path to trust policy JSON file"
  type        = string
}

variable "aws_managed_policy_arns" {
  description = "List of AWS managed policy ARNs"
  type        = list(string)
  default     = []
}

variable "inline_policies" {
  description = "Map of inline policy names to file paths"
  type        = map(string)
  default     = {}
}