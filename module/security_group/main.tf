# modules/security_groups/main.tf

resource "aws_security_group" "eks_cluster_sg" {
  name        = "${var.cluster_name}-cluster-sg"
  description = "Security group for EKS cluster control plane"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.cluster_name}-cluster-sg"
  }
}

resource "aws_security_group_rule" "cluster_egress" {
  security_group_id = aws_security_group.eks_cluster_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outbound traffic"
}

resource "aws_security_group_rule" "cluster_ingress_https" {
  security_group_id = aws_security_group.eks_cluster_sg.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.api_access_cidrs
  description       = "Allow HTTPS access to the API server"
}

resource "aws_security_group" "eks_nodes_sg" {
  name        = "${var.cluster_name}-nodes-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.cluster_name}-nodes-sg"
  }
}

resource "aws_security_group_rule" "nodes_egress" {
  security_group_id = aws_security_group.eks_nodes_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outbound traffic"
}

resource "aws_security_group_rule" "nodes_ingress_self" {
  security_group_id = aws_security_group.eks_nodes_sg.id
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
  description       = "Allow all traffic between nodes"
}

resource "aws_security_group_rule" "nodes_ingress_cluster" {
  security_group_id        = aws_security_group.eks_nodes_sg.id
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eks_cluster_sg.id
  description              = "Allow traffic from control plane to worker nodes"
}

resource "aws_security_group_rule" "cluster_ingress_nodes" {
  security_group_id        = aws_security_group.eks_cluster_sg.id
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eks_nodes_sg.id
  description              = "Allow traffic from worker nodes to control plane"
}

# Security Group for Load Balancers (ALB/NLB)
resource "aws_security_group" "load_balancers_sg" {
  name        = "${var.cluster_name}-load-balancers-sg"
  description = "Security group for ALB/NLB created by AWS Load Balancer Controller"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.cluster_name}-load-balancers"
  }
}

# Allow HTTP traffic from specified CIDR blocks
resource "aws_security_group_rule" "lb_ingress_http" {
  security_group_id = aws_security_group.load_balancers_sg.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = var.lb_ingress_cidrs
  description       = "Allow HTTP traffic"
}

# Allow HTTPS traffic from specified CIDR blocks
resource "aws_security_group_rule" "lb_ingress_https" {
  security_group_id = aws_security_group.load_balancers_sg.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.lb_ingress_cidrs
  description       = "Allow HTTPS traffic"
}

# Allow outbound traffic from load balancers
resource "aws_security_group_rule" "lb_egress" {
  security_group_id = aws_security_group.load_balancers_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outbound traffic"
}