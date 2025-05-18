region            = "us-east-1"
# vpc_id            = "vpc-0bd1562f11536b9dd"
# subnet_ids        = ["subnet-0aade558b97319d86", "subnet-0211abeb4ee6ef699"]
tags = {
  Name = "dev"
}
name = "demo"
vpc_cidr             = "10.0.0.0/16"
availability_zones   = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs  = ["10.0.6.0/24", "10.0.7.0/24"]
private_subnet_cidrs = ["10.0.4.0/24", "10.0.5.0/24"]
create_nat_gateway   = false



aws_region        = "us-west-2"
cluster_name      = "my-eks-cluster"
cluster_version   = "1.28"
role_name         = "eks-cluster-role"
vpc_subnets       = ["subnet-12345678", "subnet-23456789", "subnet-34567890"]
node_group_name   = "eks-node-group"
node_instance_type = ["t3.medium"]
node_disk_size    = 20

policy_arns = [
  "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
  "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController",
  "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
  "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
  "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
]

eks_addons = {
  "coredns"               = "v1.10.1-eksbuild.2"
  "vpc-cni"               = "v1.14.0-eksbuild.3"
  "kube-proxy"            = "v1.28.1-eksbuild.1"
  "eks-pod-identity-agent" = "v1.1.0-eksbuild.1"
}

principal_arn     = "arn:aws:iam::123456789012:user/admin"
kubernetes_groups = ["system:masters"]
access_policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"