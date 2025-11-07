output "cluster_endpoint" {
  description = "The endpoint for the EKS cluster's Kubernetes API."
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_ca_certificate" {
  description = "The base64 encoded certificate data required to communicate with the cluster."
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "cluster_name" {
  description = "The name of the EKS cluster."
  value       = aws_eks_cluster.main.name
}

output "cluster_security_group_id" {
  description = "The ID of the security group for the EKS cluster."
  value       = aws_security_group.cluster.id
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC provider for IRSA."
  value       = aws_iam_openid_connect_provider.oidc_provider.arn
}

output "argocd_iam_role_arn" {
  description = "The ARN of the IAM role for the Argo CD server service account."
  value       = aws_iam_role.argocd_server.arn
}

# --------------------------------------------------------------------------------------------------
# NOTE ON KUBECONFIG
# --------------------------------------------------------------------------------------------------
# To configure kubectl, you can use the AWS CLI:
# aws eks update-kubeconfig --name ${aws_eks_cluster.main.name} --region ${var.aws_region}
#
# NOTE ON ARGOCD BOOTSTRAPPING
# --------------------------------------------------------------------------------------------------
# After the cluster is up, you would typically bootstrap Argo CD using Helm:
# 1. Create the 'argo-cd' namespace (if not already created by Fargate profile):
#    kubectl create namespace argo-cd
#
# 2. Install Argo CD with the IRSA role annotation:
#    helm repo add argo https://argoproj.github.io/argo-helm
#    helm install argo-cd argo/argo-cd \
#      --namespace argo-cd \
#      --set server.serviceAccount.create=true \
#      --set server.serviceAccount.name="argocd-server" \
#      --set 'server.serviceAccount.annotations.eks\.amazonaws\.com/role-arn=${aws_iam_role.argocd_server.arn}'
# --------------------------------------------------------------------------------------------------