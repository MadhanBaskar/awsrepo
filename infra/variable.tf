variable "cluster_name" {
  type = string
}

variable "cluster_tags" {
  type = map
  default = {
    "terraform" = "True"
  }
}

variable "create_iam_role" {
	type = bool
	default = true
}

variable "iam_role_name" {
  type = string
  default = ""
}

variable "iam_role_tags" {
  type = map
  default = {
    "terraform" = "True"
  }
}

variable "cloudwatch_log_group_name" {
  type = string
}

variable "cloudwatch_log_group_retention" {}

variable "cloudwatch_log_group_tags" {
  type = map
  default = {
    "terraform" = "True"
  }
}

variable "task_definition_family" {}

variable "container_definition_name" {}

variable "container_definition_image" {}

variable "cd_portmapping_containerport" {}

variable "cd_portmapping_hostport" {}

variable "cd_portmapping_protocol" {}

variable "cd_env_vars" {
	type = list(map(string))
	default = []
}

variable "cd_mount_points" {
	default = []
}

variable "task_definition_cpu" {}

variable "task_definition_memory" {}

variable "td_execution_role_arn" {
	default = ""
}

variable "td_task_role_arn" {
	default = ""
}

variable "td_volumes" {
	type = map
	default = {}
}

variable "td_volume_name" {
	default = ""
}

variable "td_volume_fs_id" {
	default = ""
}

variable "td_volume_root_dir" {
	default = ""
}

variable "td_tags" {
  type = map
  default = {
    "terraform" = "True"
  }
}

variable "service_name" {}

variable "service_subnets" {
  type = list(string)
  default = []
}

variable "service_sg" {
  type = list(string)
  default = []
}

variable "service_tg_arn" {}
