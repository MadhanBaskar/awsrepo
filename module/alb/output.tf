output "alb_arn" { 
  value = aws_lb.this.arn 
  }
output "alb_dns_name" { 
  value = aws_lb.this.dns_name 
  }
output "appointment_target_group_arn" { 
  value = aws_lb_target_group.appointment.arn 
  }
output "patient_target_group_arn" { 
  value = aws_lb_target_group.patient.arn 
  }