module "vpc" {
  source                = "../module/vpc"
  name                 = "${var.name}-vpc"
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  create_nat_gateway   = var.create_nat_gateway

  tags = {
    Name = var.name
  }
}

module "eks" {
  source = "./modules/eks"

  cluster_name     = var.cluster_name
  cluster_version  = var.cluster_version
  role_name        = var.role_name
  vpc_subnets      = module.vpc.public_subnet_ids
  node_group_name  = var.node_group_name
  node_instance_type = var.node_instance_type
  node_disk_size   = var.node_disk_size
  policy_arns      = var.policy_arns
  eks_addons       = var.eks_addons
  principal_arn    = var.principal_arn
  kubernetes_groups = var.kubernetes_groups
  access_policy_arn = var.access_policy_arn
}