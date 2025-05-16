output "cluster_name" {
  value = module.ecs_cluster.name
}

output "app1_service_name" {
  value = module.app1_service.ecs_service_name
}

output "app2_service_name" {
  value = module.app2_service.ecs_service_name
}