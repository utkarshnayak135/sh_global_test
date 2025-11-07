# --------------------------------------------------------------------------------------------------
# EKS CLUSTER IAM ROLE
# --------------------------------------------------------------------------------------------------
resource "aws_iam_role" "cluster" {
  name = "${var.project_name}-${var.environment}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-eks-cluster-role"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.cluster.name
}

# --------------------------------------------------------------------------------------------------
# EKS FARGATE POD EXECUTION ROLE
# --------------------------------------------------------------------------------------------------
resource "aws_iam_role" "fargate_pod_execution" {
  name = "${var.project_name}-${var.environment}-eks-fargate-pod-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks-fargate-pods.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-fargate-pod-execution-role"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "fargate_pod_execution_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.fargate_pod_execution.name
}

# --------------------------------------------------------------------------------------------------
# IAM OIDC CONNECT PROVIDER FOR IRSA
# --------------------------------------------------------------------------------------------------
data "tls_certificate" "cluster" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "oidc_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

# --------------------------------------------------------------------------------------------------
# IAM ROLE FOR ARGOCD SERVICE ACCOUNT (IRSA)
# --------------------------------------------------------------------------------------------------
# This role allows Argo CD to manage Kubernetes resources.
# The trust policy allows the 'argocd-server' service account in the 'argo-cd' namespace
# to assume this role.
# --------------------------------------------------------------------------------------------------
resource "aws_iam_role" "argocd_server" {
  name = "${var.project_name}-${var.environment}-argocd-server-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_openid_connect_provider.oidc_provider.arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${replace(aws_iam_openid_connect_provider.oidc_provider.url, "https://", "")}:sub" = "system:serviceaccount:argo-cd:argocd-server"
          }
        }
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-argocd-server-role"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_iam_policy" "argocd_server" {
  name        = "${var.project_name}-${var.environment}-argocd-server-policy"
  description = "IAM policy for Argo CD to manage cluster resources."

  # This policy grants Argo CD administrative access.
  # For production, you might want to scope this down.
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["*"],
        Resource = ["*"]
      },
    ]
  })

  tags = {
    Name        = "${var.project_name}-argocd-server-policy"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "argocd_server" {
  policy_arn = aws_iam_policy.argocd_server.arn
  role       = aws_iam_role.argocd_server.name
}