
module "ecs_execution_role" {
  source                = "../module/iam_role"
  name                  = "ecsExecutionRole"
  trust_policy_json     = file("${path.module}/ecs_execution_trust_policy.json")
  aws_managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]
  inline_policies = {}
}

module "ecs_task_role" {
  source                = "../module/iam_role"
  name                  = "ecsTaskRole"
  trust_policy_json     = file("${path.module}/ecs_task_trust_policy.json")
  aws_managed_policy_arns = [
    # Add your custom policies here if needed
  ]
  inline_policies = {}
}

module "alb_sg" {
  source      = "../module/security_group"
  name        = "alb-sg"
  description = "Allow HTTP to ALB"
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
  tags = { Name = "alb-sg" }
}

module "alb" {
  source                  = "../module/alb"
  name                    = "ecs-demo-alb"
  security_groups         = [module.alb_sg.id]
  subnets                 = var.subnet_ids
  vpc_id                  = var.vpc_id
  tags                    = { Name = "ecs-demo-alb" }
  appointment_port        = var.appointment_port
  appointment_path        = var.appointment_path
  appointment_health_path = var.appointment_health_path
  patient_port            = var.patient_port
  patient_path            = var.patient_path
  patient_health_path     = var.patient_health_path
}

module "ecs_sg" {
  source      = "../module/security_group"
  name        = "ecs-service-sg"
  description = "Allow HTTP"
  vpc_id      = var.vpc_id
  ingress = [
    {
      from_port   = var.appointment_port
      to_port     = var.appointment_port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = var.patient_port
      to_port     = var.patient_port
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
  tags = { Name = "ecs-service-sg" }
}

module "ecs_fargate" {
  source             = "../module/ecs_fargate"
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
      name             = "appointment"
      desired_count    = var.appointment_desired_count
      security_groups  = [module.ecs_sg.id]
      assign_public_ip = true
      load_balancer = {
        target_group_arn = module.alb.appointment_target_group_arn
      }
    },
    {
      name             = "patient"
      desired_count    = var.patient_desired_count
      security_groups  = [module.ecs_sg.id]
      assign_public_ip = true
      load_balancer = {
        target_group_arn = module.alb.patient_target_group_arn
      }
    }
  ]
}