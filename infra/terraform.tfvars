region            = "us-east-1"
#tags = {
#  Name = "dev"
#}
name = "demo"
vpc_cidr             = "10.0.0.0/16"
availability_zones   = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs  = ["10.0.6.0/24", "10.0.7.0/24"]
private_subnet_cidrs = ["10.0.4.0/24", "10.0.5.0/24"]
create_nat_gateway   = false



#aws_region        = "us-east-1"
cluster_name      = "my-eks-cluster"
cluster_version   = "1.32"
role_name         = "eks-cluster-role"
node_group_name   = "eks-node-group"
node_instance_type = ["t2.medium"]
node_disk_size    = 8

policy_arns = [
  "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
  "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController",
  "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
  "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
  "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
]

eks_addons = {
  "coredns"               = "v1.11.4-eksbuild.10"
  "vpc-cni"               = "v1.19.5-eksbuild.1"
  "kube-proxy"            = "v1.32.3-eksbuild.7"
  "eks-pod-identity-agent" = "v1.3.7-eksbuild.2"
}

principal_arn     = "arn:aws:iam::676206899900:user/devops"
kubernetes_groups = ["system:masters"]
access_policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"