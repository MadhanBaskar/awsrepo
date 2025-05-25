#}

# ECS Module
module "ecs" {
  source = "./modules/ecs"

  environment                = var.environment
  vpc_id                     = module.networking.vpc_id
  private_subnet_ids         = module.networking.private_subnet_ids
  ecs_security_group_id      = module.security.ecs_security_group_id
  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
  ecs_task_role_arn          = module.iam.ecs_task_role_arn
  
  alb_target_group_appoint_arn = module.alb.target_group_appoint_arn
  alb_target_group_patient_arn = module.alb.target_group_patient_arn
  
  appoint_container_image    = var.appoint_container_image
  patient_container_image    = var.patient_container_image
  appoint_service_port       = var.appoint_service_port
  patient_service_port       = var.patient_service_port
  
  appoint_container_cpu      = var.appoint_container_cpu
  appoint_container_memory   = var.appoint_container_memory
  patient_container_cpu      = var.patient_container_cpu
  patient_container_memory   = var.patient_container_memory
  
  appoint_service_desired_count = var.appoint_service_desired_count
  patient_service_desired_count = var.patient_service_desired_count
}
```

### variables.tf
```hcl
variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "The environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
}

variable "alb_ports" {
  description = "List of ports for ALB security group"
  type        = list(number)
  default     = [80, 443]
}

variable "ecs_ports" {
  description = "List of ports for ECS security group"
  type        = list(number)
  default     = [0]
}

variable "appoint_container_image" {
  description = "Docker image for appointment service"
  type        = string
}

variable "patient_container_image" {
  description = "Docker image for patient service"
  type        = string
}

variable "appoint_service_port" {
  description = "Port for appointment service"
  type        = number
  default     = 8080
}

variable "patient_service_port" {
  description = "Port for patient service"
  type        = number
  default     = 8081
}

variable "appoint_container_cpu" {
  description = "CPU units for appointment container"
  type        = number
  default     = 256
}

variable "appoint_container_memory" {
  description = "Memory for appointment container in MiB"
  type        = number
  default     = 512
}

variable "patient_container_cpu" {
  description = "CPU units for patient container"
  type        = number
  default     = 256
}

variable "patient_container_memory" {
  description = "Memory for patient container in MiB"
  type        = number
  default     = 512
}

variable "appoint_service_desired_count" {
  description = "Desired count of appointment service tasks"
  type        = number
  default     = 2
}

variable "patient_service_desired_count" {
  description = "Desired count of patient service tasks"
  type        = number
  default     = 2
}
```

### outputs.tf
```hcl
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.networking.vpc_id
}

output "alb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = module.alb.alb_dns_name
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = module.ecs.cluster_name
}

output "ecs_appoint_service_name" {
  description = "Name of the ECS appointment service"
  value       = module.ecs.appoint_service_name
}

output "ecs_patient_service_name" {
  description = "Name of the ECS patient service"
  value       = module.ecs.patient_service_name
}
```

### terraform.tfvars
```hcl
aws_region           = "us-east-1"
environment          = "dev"
vpc_cidr             = "10.0.0.0/16"
availability_zones   = ["us-east-1a", "us-east-1b"]
private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnet_cidrs  = ["10.0.101.0/24", "10.0.102.0/24"]

alb_ports = [80, 443]
ecs_ports = [0]

appoint_container_image = "nginx:latest"  # Replace with your appointment service image
patient_container_image = "nginx:latest"  # Replace with your patient service image

appoint_service_port = 8080
patient_service_port = 8081

appoint_container_cpu    = 256
appoint_container_memory = 512
patient_container_cpu    = 256
patient_container_memory = 512

appoint_service_desired_count = 2
patient_service_desired_count = 2
```

## Module Files

### Networking Module

#### modules/networking/main.tf
```hcl
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name        = "${var.environment}-private-subnet-${count.index + 1}"
    Environment = var.environment
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.environment}-public-subnet-${count.index + 1}"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.environment}-igw"
    Environment = var.environment
  }
}

resource "aws_eip" "nat" {
  count = length(var.public_subnet_cidrs)
  domain   = "vpc"

  tags = {
    Name        = "${var.environment}-eip-${count.index + 1}"
    Environment = var.environment
  }
}

resource "aws_nat_gateway" "main" {
  count = length(var.public_subnet_cidrs)

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  depends_on    = [aws_internet_gateway.main]

  tags = {
    Name        = "${var.environment}-nat-${count.index + 1}"
    Environment = var.environment
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.environment}-public-route-table"
    Environment = var.environment
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.environment}-private-route-table-${count.index + 1}"
    Environment = var.environment
  }
}

resource "aws_route" "private" {
  count = length(var.private_subnet_cidrs)

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main[count.index].id
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
```

#### modules/networking/variables.tf
```hcl
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "environment" {
  description = "The environment name"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
}
```

#### modules/networking/outputs.tf
```hcl
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}
```

### Security Module

#### modules/security/main.tf
```hcl
resource "aws_security_group" "alb" {
  name        = "${var.environment}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.alb_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-alb-sg"
    Environment = var.environment
  }
}

resource "aws_security_group" "ecs" {
  name        = "${var.environment}-ecs-sg"
  description = "Security group for ECS services"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-ecs-sg"
    Environment = var.environment
  }
}
```

#### modules/security/variables.tf
```hcl
variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "environment" {
  description = "The environment name"
  type        = string
}

variable "alb_ports" {
  description = "List of ports for ALB security group"
  type        = list(number)
}

variable "ecs_ports" {
  description = "List of ports for ECS security group"
  type        = list(number)
}
```

#### modules/security/outputs.tf
#### modules/security/outputs.tf
```hcl
output "alb_security_group_id" {
  description = "The ID of the ALB security group"
  value       = aws_security_group.alb.id
}

output "ecs_security_group_id" {
  description = "The ID of the ECS security group"
  value       = aws_security_group.ecs.id
}
```

### IAM Module

#### modules/iam/main.tf
```hcl
# ECS Task Execution Role
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.environment}-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.environment}-ecs-execution-role"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS Task Role
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.environment}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.environment}-ecs-task-role"
    Environment = var.environment
  }
}

# Add any additional policies needed for your ECS tasks
resource "aws_iam_policy" "ecs_task_policy" {
  name        = "${var.environment}-ecs-task-policy"
  description = "Policy for ECS tasks"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_policy" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_task_policy.arn
}
```

#### modules/iam/variables.tf
```hcl
variable "environment" {
  description = "The environment name"
  type        = string
}
```

#### modules/iam/outputs.tf
```hcl
output "ecs_task_execution_role_arn" {
  description = "ARN of the ECS task execution role"
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_task_role_arn" {
  description = "ARN of the ECS task role"
  value       = aws_iam_role.ecs_task_role.arn
}
```

### ALB Module

#### modules/alb/main.tf
```hcl
resource "aws_lb" "main" {
  name               = var.name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false

  tags = {
    Name        = var.name
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "appoint" {
  name     = "${var.environment}-appoint-tg"
  port     = var.appoint_service_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  
  health_check {
    enabled             = true
    interval            = 30
    path                = "/appoint/health"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }

  tags = {
    Name        = "${var.environment}-appoint-tg"
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "patient" {
  name     = "${var.environment}-patient-tg"
  port     = var.patient_service_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  
  health_check {
    enabled             = true
    interval            = 30
    path                = "/patient/health"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }

  tags = {
    Name        = "${var.environment}-patient-tg"
    Environment = var.environment
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    
    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "appoint" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.appoint.arn
  }

  condition {
    path_pattern {
      values = ["/appoint*"]
    }
  }
}

resource "aws_lb_listener_rule" "patient" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.patient.arn
  }

  condition {
    path_pattern {
      values = ["/patient*"]
    }
  }
}
```

#### modules/alb/variables.tf
```hcl
variable "name" {
  description = "Name for the ALB"
  type        = string
}

variable "environment" {
  description = "The environment name"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "security_group_id" {
  description = "The ID of the security group for the ALB"
  type        = string
}

variable "appoint_service_port" {
  description = "The port for the appointment service"
  type        = number
}

variable "patient_service_port" {
  description = "The port for the patient service"
  type        = number
}
```

#### modules/alb/outputs.tf
```hcl
output "alb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.main.dns_name
}

output "target_group_appoint_arn" {
  description = "ARN of the appointment target group"
  value       = aws_lb_target_group.appoint.arn
}

output "target_group_patient_arn" {
  description = "ARN of the patient target group"
  value       = aws_lb_target_group.patient.arn
}
```

### ECS Module

#### modules/ecs/main.tf
```hcl
resource "aws_ecs_cluster" "main" {
  name = "${var.environment}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name        = "${var.environment}-cluster"
    Environment = var.environment
  }
}

resource "aws_cloudwatch_log_group" "appoint" {
  name              = "/ecs/${var.environment}-appoint-service"
  retention_in_days = 30

  tags = {
    Name        = "${var.environment}-appoint-log-group"
    Environment = var.environment
  }
}

resource "aws_cloudwatch_log_group" "patient" {
  name              = "/ecs/${var.environment}-patient-service"
  retention_in_days = 30

  tags = {
    Name        = "${var.environment}-patient-log-group"
    Environment = var.environment
  }
}

resource "aws_ecs_task_definition" "appoint" {
  family                   = "${var.environment}-appoint"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.appoint_container_cpu
  memory                   = var.appoint_container_memory
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn

  container_definitions = jsonencode([
    {
      name      = "${var.environment}-appoint-container"
      image     = var.appoint_container_image
      essential = true
      portMappings = [
        {
          containerPort = var.appoint_service_port
          hostPort      = var.appoint_service_port
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.appoint.name
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name        = "${var.environment}-appoint-task"
    Environment = var.environment
  }
}

resource "aws_ecs_task_definition" "patient" {
  family                   = "${var.environment}-patient"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.patient_container_cpu
  memory                   = var.patient_container_memory
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn

  container_definitions = jsonencode([
    {
      name      = "${var.environment}-patient-container"
      image     = var.patient_container_image
      essential = true
      portMappings = [
        {
          containerPort = var.patient_service_port
          hostPort      = var.patient_service_port
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.patient.name
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name        = "${var.environment}-patient-task"
    Environment = var.environment
  }
}

resource "aws_ecs_service" "appoint" {
  name            = "${var.environment}-appoint-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.appoint.arn
  desired_count   = var.appoint_service_desired_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [var.ecs_security_group_id]
    subnets          = var.private_subnet_ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.alb_target_group_appoint_arn
    container_name   = "${var.environment}-appoint-container"
    container_port   = var.appoint_service_port
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  tags = {
    Name        = "${var.environment}-appoint-service"
    Environment = var.environment
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  depends_on = [aws_ecs_task_definition.appoint]
}

resource "aws_ecs_service" "patient" {
  name            = "${var.environment}-patient-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.patient.arn
  desired_count   = var.patient_service_desired_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [var.ecs_security_group_id]
    subnets          = var.private_subnet_ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.alb_target_group_patient_arn
    container_name   = "${var.environment}-patient-container"
    container_port   = var.patient_service_port
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  tags = {
    Name        = "${var.environment}-patient-service"
    Environment = var.environment
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  depends_on = [aws_ecs_task_definition.patient]
}
```

#### modules/ecs/variables.tf
```hcl
variable "environment" {
  description = "The environment name"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "The ID of the security group for ECS services"
  type        = string
}

variable "ecs_task_execution_role_arn" {
  description = "ARN of the ECS task execution role"
  type        = string
}

variable "ecs_task_role_arn" {
  description = "ARN of the ECS task role"
  type        = string
}

variable "alb_target_group_appoint_arn" {
  description = "ARN of the appointment target group"
  type        = string
}

variable "alb_target_group_patient_arn" {
  description = "ARN of the patient target group"
  type        = string
}

variable "appoint_container_image" {
  description = "Docker image for appointment service"
  type        = string
}

variable "patient_container_image" {
  description = "Docker image for patient service"
  type        = string
}

variable "appoint_service_port" {
  description = "Port for appointment service"
  type        = number
}

variable "patient_service_port" {
  description = "Port for patient service"
  type        = number
}

variable "appoint_container_cpu" {
  description = "CPU units for appointment container"
  type        = number
}

variable "appoint_container_memory" {
  description = "Memory for appointment container in MiB"
  type        = number
}

variable "patient_container_cpu" {
  description = "CPU

  #### modules/ecs/variables.tf (completed)
```hcl
variable "environment" {
  description = "The environment name"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "The ID of the security group for ECS services"
  type        = string
}

variable "ecs_task_execution_role_arn" {
  description = "ARN of the ECS task execution role"
  type        = string
}

variable "ecs_task_role_arn" {
  description = "ARN of the ECS task role"
  type        = string
}

variable "alb_target_group_appoint_arn" {
  description = "ARN of the appointment target group"
  type        = string
}

variable "alb_target_group_patient_arn" {
  description = "ARN of the patient target group"
  type        = string
}

variable "appoint_container_image" {
  description = "Docker image for appointment service"
  type        = string
}

variable "patient_container_image" {
  description = "Docker image for patient service"
  type        = string
}

variable "appoint_service_port" {
  description = "Port for appointment service"
  type        = number
}

variable "patient_service_port" {
  description = "Port for patient service"
  type        = number
}

variable "appoint_container_cpu" {
  description = "CPU units for appointment container"
  type        = number
}

variable "appoint_container_memory" {
  description = "Memory for appointment container in MiB"
  type        = number
}

variable "patient_container_cpu" {
  description = "CPU units for patient container"
  type        = number
}

variable "patient_container_memory" {
  description = "Memory for patient container in MiB"
  type        = number
}

variable "appoint_service_desired_count" {
  description = "Desired count of appointment service tasks"
  type        = number
}

variable "patient_service_desired_count" {
  description = "Desired count of patient service tasks"
  type        = number
}
```

### Adding ECS Module Outputs

Now let's add the outputs file that was missing:

#### modules/ecs/outputs.tf
```hcl
output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "cluster_id" {
  description = "ID of the ECS cluster"
  value       = aws_ecs_cluster.main.id
}

output "appoint_service_name" {
  description = "Name of the appointment service"
  value       = aws_ecs_service.appoint.name
}

output "patient_service_name" {
  description = "Name of the patient service"
  value       = aws_ecs_service.patient.name
}

output "appoint_task_definition_arn" {
  description = "ARN of the appointment task definition"
  value       = aws_ecs_task_definition.appoint.arn
}

output "patient_task_definition_arn" {
  description = "ARN of the patient task definition"
  value       = aws_ecs_task_definition.patient.arn
}
```

### Adding Auto Scaling Configuration (Optional but Recommended)

Let's add auto scaling for the ECS services:

#### modules/ecs/autoscaling.tf
```hcl
resource "aws_appautoscaling_target" "appoint" {
  max_capacity       = 10
  min_capacity       = var.appoint_service_desired_count
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.appoint.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "appoint_cpu" {
  name               = "${var.environment}-appoint-cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.appoint.resource_id
  scalable_dimension = aws_appautoscaling_target.appoint.scalable_dimension
  service_namespace  = aws_appautoscaling_target.appoint.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 70.0
  }
}

resource "aws_appautoscaling_policy" "appoint_memory" {
  name               = "${var.environment}-appoint-memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.appoint.resource_id
  scalable_dimension = aws_appautoscaling_target.appoint.scalable_dimension
  service_namespace  = aws_appautoscaling_target.appoint.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value = 70.0
  }
}

resource "aws_appautoscaling_target" "patient" {
  max_capacity       = 10
  min_capacity       = var.patient_service_desired_count
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.patient.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "patient_cpu" {
  name               = "${var.environment}-patient-cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.patient.resource_id
  scalable_dimension = aws_appautoscaling_target.patient.scalable_dimension
  service_namespace  = aws_appautoscaling_target.patient.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 70.0
  }
}

resource "aws_appautoscaling_policy" "patient_memory" {
  name               = "${var.environment}-patient-memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.patient.resource_id
  scalable_dimension = aws_appautoscaling_target.patient.scalable_dimension
  service_namespace  = aws_appautoscaling_target.patient.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value = 70.0
  }
}
```

### Adding CloudWatch Alarms (Optional but Recommended)

Let's add CloudWatch alarms to monitor the ECS services:

#### modules/ecs/alarms.tf
```hcl
resource "aws_cloudwatch_metric_alarm" "appoint_cpu_high" {
  alarm_name          = "${var.environment}-appoint-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "85"
  alarm_description   = "This metric monitors high cpu utilization for appointment service"
  
  dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.appoint.name
  }
  
  alarm_actions = []
}

resource "aws_cloudwatch_metric_alarm" "patient_cpu_high" {
  alarm_name          = "${var.environment}-patient-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "85"
  alarm_description   = "This metric monitors high cpu utilization for patient service"
  
  dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.patient.name
  }
  
  alarm_actions = []
}

resource "aws_cloudwatch_metric_alarm" "appoint_memory_high" {
  alarm_name          = "${var.environment}-appoint-memory-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "85"
  alarm_description   = "This metric monitors high memory utilization for appointment service"
  
  dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.appoint.name
  }
  
  alarm_actions = []
}

resource "aws_cloudwatch_metric_alarm" "patient_memory_high" {
  alarm_name          = "${var.environment}-patient-memory-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "85"
  alarm_description   = "This metric monitors high memory utilization for patient service"
  
  dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.patient.name
  }
  
  alarm_actions = []
}
```

### Sample README file

Let's also add a README.md file to document the project:

#### README.md
```markdown
# AWS ECS Infrastructure with Terraform

This project contains Terraform code to deploy an ECS cluster with two services (appointment and patient services) along with an Application Load Balancer for routing traffic based on path patterns.

## Architecture

- VPC with public and private subnets across two availability zones
- NAT Gateways for private subnet internet access
- Application Load Balancer with path-based routing
- ECS Cluster with Fargate launch type
- Two ECS services with separate path routing
  - `/appoint*` routes to the appointment service
  - `/patient*` routes to the patient service
- Auto-scaling capabilities for both services
- CloudWatch monitoring and logging

## Module Structure

- **networking**: VPC, subnets, route tables, internet gateway, NAT gateways
- **security**: Security groups for ALB and ECS services
- **iam**: IAM roles and policies for ECS tasks
- **alb**: Application Load Balancer, target groups, and listener rules
- **ecs**: ECS cluster, task definitions, services, auto-scaling, and alarms

## Usage

1. Initialize Terraform:
   ```
   terraform init
   ```

2. Review the execution plan:
   ```
   terraform plan -var-file=terraform.tfvars
   ```

3. Apply the configuration:
   ```
   terraform apply -var-file=terraform.tfvars
   ```

4. To destroy the infrastructure:
   ```
   terraform destroy -var-file=terraform.tfvars
   ```

## Configuration

Customize the deployment by modifying `terraform.tfvars` file with your specific requirements.

## Requirements

- Terraform v1.0+
- AWS CLI configured with appropriate credentials
- Docker images for your services must be accessible 

## Notes

- The health check paths are configured as `/appoint/health` and `/patient/health`. Adjust these in the ALB module if your application uses different health check endpoints.
- Auto-scaling is configured to scale based on CPU and memory utilization.
- CloudWatch alarms are set up to alert when CPU or memory utilization exceeds 85%.
```

This completes all the required modules for the infrastructure. The entire setup now includes:

1. A complete VPC with public and private subnets
2. Security groups for ALB and ECS
3. IAM roles for ECS tasks
4. An Application Load Balancer with path-based routing
5. An ECS cluster with two Fargate services
6. Auto-scaling configuration for both services
7. CloudWatch alarms and logging

All of these resources are organized in a modular structure for better maintainability and reusability. The code follows Terraform best practices with proper variable definitions, outputs, and tagging.
