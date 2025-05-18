# modules/security_groups/outputs.tf

output "cluster_security_group_id" {
  description = "ID of the EKS cluster security group"
  value       = aws_security_group.eks_cluster_sg.id
}

output "nodes_security_group_id" {
  description = "ID of the EKS nodes security group"
  value       = aws_security_group.eks_nodes_sg.id
}

output "load_balancers_security_group_id" {
  description = "ID of the load balancers security group"
  value       = aws_security_group.load_balancers_sg.id
}