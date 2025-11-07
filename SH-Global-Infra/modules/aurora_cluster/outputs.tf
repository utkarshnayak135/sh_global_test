output "cluster_endpoint" {
  description = "The endpoint for the Aurora cluster writer instance."
  value       = aws_rds_cluster.default.endpoint
}

output "cluster_reader_endpoint" {
  description = "The endpoint for the Aurora cluster reader instances."
  value       = aws_rds_cluster.default.reader_endpoint
}

output "cluster_id" {
  description = "The ID of the Aurora cluster."
  value       = aws_rds_cluster.default.id
}

output "security_group_id" {
  description = "The ID of the security group for the Aurora cluster."
  value       = aws_security_group.aurora.id
}