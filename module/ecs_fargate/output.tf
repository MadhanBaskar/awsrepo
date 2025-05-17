output "ecs_cluster_id" {
  value = aws_ecs_cluster.this.id
}

output "ecs_service1_arn" {
  value = aws_ecs_service.this["service1"].id
}

output "ecs_service1_name" {
  value = aws_ecs_service.this["service1"].name
}
output "ecs_task_definition_arn" {
  value = aws_ecs_task_definition.this.arn
}