variable "project_name" {
  description = "The name of the project, used for tagging resources."
  type        = string
}

variable "environment" {
  description = "The environment name, used for tagging resources."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the cluster will be deployed."
  type        = string
}

variable "private_subnet_ids" {
  description = "A list of private subnet IDs for the EKS control plane and Fargate pods."
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "A list of public subnet IDs for the EKS control plane."
  type        = list(string)
}

variable "cluster_version" {
  description = "The Kubernetes version for the EKS cluster."
  type        = string
  default     = "1.23"
}

variable "fargate_profiles" {
  description = "A map of Fargate profiles to create. Key is the profile name, value is the namespace."
  type        = map(string)
  default = {
    app-services = "app-services"
    argo-cd      = "argo-cd"
  }
}