output "cluster_arn" {
  description = "The ARN of the MSK cluster."
  value       = aws_msk_cluster.default.arn
}

output "bootstrap_brokers_tls" {
  description = "A comma-separated list of the bootstrap broker endpoints for TLS connections."
  value       = aws_msk_cluster.default.bootstrap_brokers_tls
}

output "bootstrap_brokers_plaintext" {
  description = "A comma-separated list of the bootstrap broker endpoints for PLAINTEXT connections."
  value       = aws_msk_cluster.default.bootstrap_brokers
}

output "zookeeper_connect_string" {
  description = "The Zookeeper connection string for the MSK cluster."
  value       = aws_msk_cluster.default.zookeeper_connect_string
}