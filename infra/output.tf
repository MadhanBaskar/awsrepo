output "ecs_cluster_id" {
  value = module.ecs_fargate.ecs_cluster_id
}

output "ecs_service_names" {
  value = module.ecs_fargate.ecs_service_names
}

output "ecs_service_arns" {
  value = module.ecs_fargate.ecs_service_arns
}

output "ecs_task_definition_arn" {
  value = module.ecs_fargate.ecs_task_definition_arn
}