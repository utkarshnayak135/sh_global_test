variable "domain_name" {
  description = "The domain name for which to create the Route 53 zone and records."
  type        = string
}

variable "app_load_balancer_dns_name" {
  description = "The DNS name of the application load balancer to point the Alias record to."
  type        = string
}

variable "app_load_balancer_zone_id" {
  description = "The zone ID of the application load balancer."
  type        = string
}

variable "project_name" {
  description = "The name of the project, used for tagging resources."
  type        = string
}

variable "environment" {
  description = "The environment name, used for tagging resources."
  type        = string
}