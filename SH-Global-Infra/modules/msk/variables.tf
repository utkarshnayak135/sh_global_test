variable "project_name" {
  description = "The name of the project, used for tagging resources."
  type        = string
}

variable "environment" {
  description = "The environment name, used for tagging resources."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the MSK cluster will be deployed."
  type        = string
}

variable "private_subnet_ids" {
  description = "A list of private subnet IDs for the MSK brokers."
  type        = list(string)
}

variable "eks_cluster_sg_id" {
  description = "The security group ID of the EKS cluster to allow access."
  type        = string
}

variable "kafka_version" {
  description = "The desired Kafka software version."
  type        = string
  default     = "2.8.1"
}

variable "number_of_broker_nodes" {
  description = "The number of broker nodes in the Kafka cluster."
  type        = number
  default     = 2
}

variable "broker_node_instance_type" {
  description = "The AWS instance type for the Kafka broker nodes."
  type        = string
  default     = "kafka.m5.large"
}