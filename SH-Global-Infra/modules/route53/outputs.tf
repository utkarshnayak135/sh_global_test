output "hosted_zone_id" {
  description = "The ID of the Route 53 hosted zone."
  value       = data.aws_route53_zone.selected.zone_id
}

output "hosted_zone_name_servers" {
  description = "A list of name servers for the hosted zone."
  value       = data.aws_route53_zone.selected.name_servers
}

output "app_fqdn" {
  description = "The fully qualified domain name (FQDN) of the application."
  value       = aws_route53_record.app.fqdn
}