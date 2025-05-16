provider "aws" {
  region = var.aws_region
}

module "ecs_execution_role" {
  source                = "../modules/iam_role"
  name                  = "ecsExecutionRole"
  trust_policy_json     = "${path.module}/ecs_execution_trust_policy.json"
  aws_managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]
  inline_policies = {}
}

module "ecs_task_role" {
  source                = "../modules/iam_role"
  name                  = "ecsTaskRole"
  trust_policy_json     = "${path.module}/ecs_task_trust_policy.json"
  aws_managed_policy_arns = [
    # Add your custom policies here if needed
  ]
  inline_policies = {}
}

module "ecs_sg" {
  source      = "../modules/security_group"
  name        = "ecs-service-sg"
  description = "Allow HTTP"
  vpc_id      = var.vpc_id
  ingress = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  egress = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  tags = {
    Name = "ecs-service-sg"
  }
}

module "ecs_fargate" {
  source             = "../modules/ecs_fargate"
  cluster_name       = var.cluster_name
  task_family        = var.task_family
  cpu                = var.cpu
  memory             = var.memory
  execution_role_arn = module.ecs_execution_role.arn
  task_role_arn      = module.ecs_task_role.arn
  container_name     = var.container_name
  container_image    = var.container_image
  container_port     = var.container_port
  subnet_ids         = var.subnet_ids
  services = [
    {
      name             = "service1"
      desired_count    = 2
      security_groups  = [module.ecs_sg.id]
      assign_public_ip = true
      load_balancer = {
        target_group_arn = var.lb_target_group_arn_1
      }
    },
    {
      name             = "service2"
      desired_count    = 1
      security_groups  = [module.ecs_sg.id]
      assign_public_ip = true
      load_balancer = {
        target_group_arn = var.lb_target_group_arn_2
      }
    }
  ]
}