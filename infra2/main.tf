# ECS Cluster Module
module "ecs_cluster" {
  source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/ecs_cluster?ref=main"
  name   = var.cluster_name
}

# App 1
module "app1_service" {
  source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/ecs_fargate?ref=main"
  cluster_name        = module.ecs_cluster.name
  task_family         = var.app1_task_family
  cpu                 = var.app1_cpu
  memory              = var.app1_memory
  execution_role_arn  = var.execution_role_arn
  task_role_arn       = var.task_role_arn
  container_name      = var.app1_container_name
  container_image     = var.app1_container_image
  container_port      = var.app1_container_port
  service_name        = var.app1_service_name
  desired_count       = var.app1_desired_count
  subnets             = var.subnets
  security_groups     = var.security_groups
  assign_public_ip    = var.assign_public_ip
}

# App 2
module "app2_service" {
  source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/ecs_fargate?ref=main"
  cluster_name        = module.ecs_cluster.name
  task_family         = var.app2_task_family
  cpu                 = var.app2_cpu
  memory              = var.app2_memory
  execution_role_arn  = var.execution_role_arn
  task_role_arn       = var.task_role_arn
  container_name      = var.app2_container_name
  container_image     = var.app2_container_image
  container_port      = var.app2_container_port
  service_name        = var.app2_service_name
  desired_count       = var.app2_desired_count
  subnets             = var.subnets
  security_groups     = var.security_groups
  assign_public_ip    = var.assign_public_ip
}