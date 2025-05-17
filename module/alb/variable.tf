variable "name" { 
  type = string 
}
variable "security_groups" {
  type = list(string) 
}
variable "subnets" { 
  type = list(string) 
}
variable "vpc_id" { 
  type = string 
}
variable "tags" { 
  type = map(string) 
  default = {} 
}

variable "appointment_port" { 
  type = number 
}
variable "appointment_path" { 
  type = string 
}
variable "appointment_health_path" { 
  type = string 
}

variable "patient_port" {
  type = number 
}
variable "patient_path" { 
  type = string 
}
variable "patient_health_path" { 
  type = string 
}