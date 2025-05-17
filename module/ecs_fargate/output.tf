output "ecs_cluster_id" {
  value = aws_ecs_cluster.this.id
}

output "ecs_service_arns" {
  value = [for svc in values(aws_ecs_service.this) : svc.arn]
}

output "ecs_service_names" {
  value = [for svc in values(aws_ecs_service.this) : svc.name]
}
output "ecs_task_definition_arn" {
  value = aws_ecs_task_definition.this.arn
}