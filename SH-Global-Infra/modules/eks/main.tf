# --------------------------------------------------------------------------------------------------
# CLUSTER SECURITY GROUP
# --------------------------------------------------------------------------------------------------
resource "aws_security_group" "cluster" {
  name        = "${var.project_name}-${var.environment}-eks-cluster-sg"
  description = "Security group for the EKS cluster control plane and nodes."
  vpc_id      = var.vpc_id

  # Allow all traffic within the cluster SG for node-to-node communication
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-eks-cluster-sg"
    Project     = var.project_name
    Environment = var.environment
  }
}

# --------------------------------------------------------------------------------------------------
# EKS CLUSTER
# --------------------------------------------------------------------------------------------------
resource "aws_eks_cluster" "main" {
  name     = "${var.project_name}-${var.environment}-eks-cluster"
  role_arn = aws_iam_role.cluster.arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids              = concat(var.public_subnet_ids, var.private_subnet_ids)
    security_group_ids      = [aws_security_group.cluster.id]
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  tags = {
    Name        = "${var.project_name}-eks-cluster"
    Project     = var.project_name
    Environment = var.environment
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSServicePolicy,
  ]
}

# --------------------------------------------------------------------------------------------------
# FARGATE PROFILES

# This section creates Fargate profiles for the namespaces defined in the 'fargate_profiles' variable.
# This ensures that pods scheduled in these namespaces will run on AWS Fargate.
# --------------------------------------------------------------------------------------------------
resource "aws_eks_fargate_profile" "profiles" {
  for_each               = var.fargate_profiles
  cluster_name           = aws_eks_cluster.main.name
  fargate_profile_name   = "${var.project_name}-${each.key}-profile"
  pod_execution_role_arn = aws_iam_role.fargate_pod_execution.arn
  subnet_ids             = var.private_subnet_ids

  selector {
    namespace = each.value
  }

  tags = {
    Name        = "${var.project_name}-fargate-${each.key}-profile"
    Project     = var.project_name
    Environment = var.environment
  }

  depends_on = [aws_iam_role_policy_attachment.fargate_pod_execution_policy]
}