provider "aws" {
  region = var.aws_region
}

# --------------------------------------------------------------------------------------------------
# MODULES
# --------------------------------------------------------------------------------------------------

module "vpc" {
  source = "../../modules/vpc"

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones
}

module "aurora_cluster" {
  source = "../../modules/aurora_cluster"

  project_name      = var.project_name
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  db_username       = var.db_username
  db_password       = var.db_password
}

module "msk" {
  source = "../../modules/msk"

  project_name       = var.project_name
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  eks_cluster_sg_id  = module.eks.cluster_security_group_id # Assumes EKS module outputs this
}

module "eks" {
  source = "../../modules/eks"

  project_name      = var.project_name
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids
}

module "route53" {
  source = "../../modules/route53"

  domain_name = var.domain_name
  # This assumes the application load balancer is created in EKS and its DNS name is exposed.
  # For now, we'll point it to a placeholder. This would typically be an output from the EKS module
  # or retrieved via a Kubernetes provider data source after the LB is created by Argo CD.
  app_load_balancer_dns_name = "placeholder-lb.eu-west-1.elb.amazonaws.com"
  app_load_balancer_zone_id  = "Z32O12XQLNTSW2" # Placeholder for eu-west-1 ELB zone ID
}

module "iam_policy" {
  source = "../../modules/iam/iam_policy"

  managed_policies = {
    admin_dev = "arn:aws:iam::aws:policy/AdministartorAccess"
  }
  
  custom_policies = {
    devops_dev = "devops_dev_policy.json"
    developer_dev = "developer_dev_policy.json"
  }
}

module "iam_role" {
  source = "../../modules/iam/iam_role"

  roles = {
    admin_dev = {
      policy_arn = module.iam_policy.policy_arns["admin_dev"]
    }
    devops_dev = {
      policy_arn = module.iam_policy.policy_arns["devops_dev"]
    }
    developer_dev = {
      policy_arn = module.iam_policy.policy_arns["developer_dev"]
    }
  }
  
}

module "iam_group" {
  source = "../../modules/iam/iam_group"

  groups = {
    admin_dev = {
      policy_arn = module.iam_policy.policy_arns["admin_dev"]
      role_arn = module.iam_role.role_arns["admin_dev"]
    }
    devops_dev = {
      policy_arn = module.iam_policy.policy_arns["devops_dev"]
      role_arn = module.iam_role.role_arns["devops_dev"]
    }
    developer_dev = {
      policy_arn = module.iam_policy.policy_arns["developer_dev"]
      role_arn = module.iam_role.role_arns["developer_dev"]
    }
  }
}