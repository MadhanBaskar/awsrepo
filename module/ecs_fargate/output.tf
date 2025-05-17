output "ecs_cluster_id" {
  value = aws_ecs_cluster.this.id
}

output "ecs_service_names" {
  value = [for svc in values(aws_ecs_service.this) : svc.name]
}

output "ecs_service_ids" {
  value = [for svc in values(aws_ecs_service.this) : svc.id]
}

output "ecs_task_definition_arns" {
  value = [for td in values(aws_ecs_task_definition.this) : td.arn]
}