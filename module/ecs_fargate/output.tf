output "ecs_cluster_id" {
  value = aws_ecs_cluster.this.id
}

output "ecs_service_arns" {
  value = [for svc in aws_ecs_service.this : svc.value.arn]
}

output "ecs_service_names" {
  value = [for svc in aws_ecs_service.this : svc.value.name]
}

output "ecs_task_definition_arn" {
  value = aws_ecs_task_definition.this.arn
}