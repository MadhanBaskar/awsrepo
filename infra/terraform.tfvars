region            = "us-east-1"
cluster_name      = "demo-ecs-cluster"
task_family       = "demo-task-family"
cpu               = "256"
memory            = "512"
#execution_role_arn = "arn:aws:iam::123456789012:role/ecsExecutionRole"
#task_role_arn      = "arn:aws:iam::123456789012:role/ecsTaskRole"
container_name     = "my-app"
container_image    = "nginx:latest"
container_port     = 80
vpc_id             = "vpc-0abc1234def567890"
subnet_ids         = ["subnet-0123456789abcdef0", "subnet-0fedcba9876543210"]

lb_target_group_arn_1 = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/service1-tg/abc123def456"
lb_target_group_arn_2 = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/service2-tg/def456abc123"

services = [
  {
    name             = "service1"
    desired_count    = 2
    security_groups  = ["sg-0123456789abcdef0"]
    assign_public_ip = true
    load_balancer = {
      target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/service1-tg/abc123def456"
    }
  },
  {
    name             = "service2"
    desired_count    = 1
    security_groups  = ["sg-0123456789abcdef0"]
    assign_public_ip = true
    load_balancer = {
      target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/service2-tg/def456abc123"
    }
  }
]