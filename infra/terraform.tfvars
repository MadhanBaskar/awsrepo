region = "us-east-1"

cluster_name = "demo-fargate-cluster"

execution_role_arn = "arn:aws:iam::123456789012:role/ecsTaskExecutionRole"
# task_role_arn      = "arn:aws:iam::123456789012:role/appTaskRole"

subnets         = ["subnet-abc123", "subnet-def456"]
security_groups = ["sg-001122334455"]
assign_public_ip = true

# App 1 - NGINX
app1_task_family       = "appointment-task"
app1_cpu               = "256" 
app1_memory            = "512"
app1_container_name    = "nginx"
app1_container_image   = "nginx:latest"
app1_container_port    = 80
app1_service_name      = "nginx-service"
app1_desired_count     = 1

# App 2 - HTTPD
app2_task_family       = "patient-task"
app2_cpu               = "256"
app2_memory            = "512"
app2_container_name    = "patient-container"
app2_container_image   = "httpd:latest"
app2_container_port    = 80
app2_service_name      = "httpd-service"
app2_desired_count     = 1