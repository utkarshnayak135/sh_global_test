variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "eu-west-1"
}

variable "environment" {
  description = "The deployment environment name."
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "The name of the project."
  type        = string
  default     = "SH"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "public_subnets" {
  description = "A list of public subnet CIDR blocks."
  type        = list(string)
}

variable "private_subnets" {
  description = "A list of private subnet CIDR blocks."
  type        = list(string)
}

variable "availability_zones" {
  description = "A list of availability zones to deploy resources into."
  type        = list(string)
}

variable "db_username" {
  description = "The username for the RDS Aurora database."
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "The password for the RDS Aurora database."
  type        = string
  sensitive   = true
}

variable "domain_name" {
  description = "The domain name for the application's DNS."
  type        = string
}