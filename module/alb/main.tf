# modules/alb/main.tf

terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Application Load Balancer
resource "aws_lb" "this" {
  name               = "${var.name_prefix}-alb"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  enable_deletion_protection = var.enable_deletion_protection
  drop_invalid_header_fields = var.drop_invalid_header_fields
  idle_timeout               = var.idle_timeout
  
  dynamic "access_logs" {
    for_each = var.access_logs_bucket != null ? [1] : []
    
    content {
      bucket  = var.access_logs_bucket
      prefix  = var.access_logs_prefix
      enabled = true
    }
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-alb"
    }
  )
}

# Target Groups
resource "aws_lb_target_group" "this" {
  for_each = var.target_groups

  name     = "${var.name_prefix}-${each.key}-tg"
  port     = each.value.port
  protocol = each.value.protocol
  vpc_id   = var.vpc_id
  
  target_type = lookup(each.value, "target_type", "instance")
  
  dynamic "health_check" {
    for_each = lookup(each.value, "health_check", null) != null ? [each.value.health_check] : []
    
    content {
      enabled             = lookup(health_check.value, "enabled", true)
      interval            = lookup(health_check.value, "interval", 30)
      path                = lookup(health_check.value, "path", "/")
      port                = lookup(health_check.value, "port", "traffic-port")
      healthy_threshold   = lookup(health_check.value, "healthy_threshold", 3)
      unhealthy_threshold = lookup(health_check.value, "unhealthy_threshold", 3)
      timeout             = lookup(health_check.value, "timeout", 5)
      protocol            = lookup(health_check.value, "protocol", "HTTP")
      matcher             = lookup(health_check.value, "matcher", "200")
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-${each.key}-tg"
    }
  )
}

# Target Group Attachments
# resource "aws_lb_target_group_attachment" "this" {
#   for_each = { 
#     for attach in var.target_group_attachments : "${attach.target_group_key}-${attach.target_id}" => attach 
#   }
  
#   target_group_arn = aws_lb_target_group.this[each.value.target_group_key].arn
#   target_id        = each.value.target_id
#   port             = lookup(each.value, "port", null)
# }

resource "aws_lb_target_group_attachment" "this" {
  count = length(var.target_group_attachments)
  
  target_group_arn = aws_lb_target_group.this[var.target_group_attachments[count.index].target_group_key].arn
  target_id        = var.target_group_attachments[count.index].target_id
  port             = lookup(var.target_group_attachments[count.index], "port", null)
}


# ALB Listener (HTTP)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.http_port
  protocol          = "HTTP"
  
  # Default action - forward to default target group
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[var.default_target_group_key].arn
  }

  depends_on = [
    aws_lb.this,
    aws_lb_target_group.this
  ]
  
  lifecycle {
    create_before_destroy = true
    # ignore_changes = [tags]
  }
  # tags = merge(
  #   var.tags,
  #   {
  #     Name = "${var.name_prefix}-http-listener"
  #   }
  # )
}

# ALB Listener Rules
resource "aws_lb_listener_rule" "path_based" {
  for_each = var.path_based_rules

  listener_arn = aws_lb_listener.http.arn
  priority     = each.value.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[each.value.target_group_key].arn
  }

  condition {
    path_pattern {
      values = each.value.path_patterns
    }
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-${each.key}-rule"
    }
  )
}

# Additional Listeners
resource "aws_lb_listener" "additional" {
  for_each = var.additional_listeners

  load_balancer_arn = aws_lb.this.arn
  port              = each.value.port
  protocol          = each.value.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[each.value.target_group_key].arn
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-${each.key}-listener"
    }
  )
}

# Additional Listener Rules
resource "aws_lb_listener_rule" "additional" {
  for_each = var.additional_listener_rules

  listener_arn = aws_lb_listener.additional[each.value.listener_key].arn
  priority     = each.value.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[each.value.target_group_key].arn
  }

  condition {
    path_pattern {
      values = each.value.path_patterns
    }
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-${each.key}-rule"
    }
  )
}

# HTTPS Listener (Optional)
resource "aws_lb_listener" "https" {
  count = var.certificate_arn != null ? 1 : 0
  
  load_balancer_arn = aws_lb.this.arn
  port              = var.https_port
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[var.default_target_group_key].arn
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-https-listener"
    }
  )
}

# HTTPS Listener Rules (if HTTPS is enabled)
resource "aws_lb_listener_rule" "https_path_based" {
  for_each = var.certificate_arn != null ? var.path_based_rules : {}

  listener_arn = aws_lb_listener.https[0].arn
  priority     = each.value.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[each.value.target_group_key].arn
  }

  condition {
    path_pattern {
      values = each.value.path_patterns
    }
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-https-${each.key}-rule"
    }
  )
}