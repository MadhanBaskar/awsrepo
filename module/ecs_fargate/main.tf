resource "aws_ecs_cluster" "this" {
  name = var.cluster_name
}

resource "aws_ecs_task_definition" "this" {
  for_each                 = { for svc in var.services : svc.name => svc }
  family                   = each.value.name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = each.value.cpu
  memory                   = each.value.memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = each.value.container_name
      image     = each.value.container_image
      cpu       = each.value.cpu
      memory    = each.value.memory
      essential = true
      portMappings = [
        {
          containerPort = each.value.container_port
          hostPort      = each.value.container_port
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "this" {
  for_each        = { for svc in var.services : svc.name => svc }
  name            = each.value.name
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this[each.key].arn
  desired_count   = each.value.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    assign_public_ip = each.value.assign_public_ip
    security_groups  = each.value.security_groups
  }

  dynamic "load_balancer" {
    for_each = each.value.load_balancer != null ? [each.value.load_balancer] : []
    content {
      target_group_arn = load_balancer.value.target_group_arn
      container_name   = each.value.container_name
      container_port   = each.value.container_port
    }
  }

  depends_on = [aws_ecs_task_definition.this]
}