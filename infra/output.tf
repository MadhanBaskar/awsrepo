output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "The endpoint URL for the EKS cluster"
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "The certificate authority data for the cluster"
  value       = module.eks.cluster_certificate_authority_data
  sensitive   = true
}

output "cluster_arn" {
  description = "The ARN of the EKS cluster"
  value       = module.eks.cluster_arn
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC provider"
  value       = module.eks.oidc_provider_arn
}

output "node_group_name" {
  description = "The name of the EKS node group"
  value       = module.eks.node_group_name
}

output "node_group_instance_types" {
  description = "The instance types used in the EKS node group"
  value       = module.eks.node_group_instance_types
}

output "node_group_disk_size" {
  description = "The disk size for the EKS node group instances"
  value       = module.eks.node_group_disk_size
}

output "iam_role_name" {
  description = "The name of the IAM role used for the EKS cluster"
  value       = module.eks.iam_role_name
}

output "vpc_subnets" {
  description = "The VPC subnets used by the EKS cluster"
  value       = module.eks.vpc_subnets
}

output "addon_versions" {
  description = "The versions of the EKS addons"
  value = {
    coredns                 = module.eks.coredns_addon_version
    vpc_cni                 = module.eks.vpc_cni_addon_version
    kube_proxy              = module.eks.kube_proxy_addon_version
    eks_pod_identity_agent  = module.eks.eks_pod_identity_agent_addon_version
  }
}

output "access_entry_principal_arn" {
  description = "The ARN of the principal for the access entry"
  value       = module.eks.access_entry_principal_arn
}

output "access_policy_arn" {
  description = "The ARN of the access policy associated with the EKS cluster"
  value       = module.eks.access_policy_arn
}

output "security_groups" {
  description = "Security group IDs for the EKS cluster"
  value = {
    cluster_sg       = module.security_groups.cluster_security_group_id
    nodes_sg         = module.security_groups.nodes_security_group_id
    load_balancers_sg = module.security_groups.load_balancers_security_group_id
  }
}

output "aws_lb_controller_role_arn" {
  description = "ARN of the IAM role for the AWS Load Balancer Controller"
  value       = module.eks.aws_lb_controller_role_arn
}

output "aws_lb_controller_policy_arn" {
  description = "ARN of the IAM policy for the AWS Load Balancer Controller"
  value       = module.eks.aws_lb_controller_policy_arn
}