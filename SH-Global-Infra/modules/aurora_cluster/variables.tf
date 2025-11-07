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
  description = "A list of private subnet IDs for the DB subnet group."
  type        = list(string)
}

variable "db_username" {
  description = "The master username for the Aurora cluster."
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "The master password for the Aurora cluster."
  type        = string
  sensitive   = true
}

variable "instance_class" {
  description = "The instance class for the Aurora DB instances."
  type        = string
  default     = "db.r5.large"
}

variable "cluster_size" {
  description = "The number of instances in the Aurora cluster."
  type        = number
  default     = 2
}