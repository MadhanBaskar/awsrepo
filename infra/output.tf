output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "ecs_service_names" {
  value = module.ecs_fargate.ecs_service_names
}

output "ecs_service_ids" {
  value = module.ecs_fargate.ecs_service_ids
}

output "ecs_task_definition_arns" {
  value = module.ecs_fargate.ecs_task_definition_arns
}