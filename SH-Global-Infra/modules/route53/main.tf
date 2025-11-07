# --------------------------------------------------------------------------------------------------
# ROUTE 53 HOSTED ZONE
#
# This will create a new public hosted zone for the specified domain name.
# If you are using an existing domain registered elsewhere, you will need to update
# the name servers at your domain registrar to the ones provided in this zone's output.
# If the domain is registered with Route 53, this happens automatically.
# --------------------------------------------------------------------------------------------------
data "aws_route53_zone" "selected" {
  name         = var.domain_name
  private_zone = false
}

# --------------------------------------------------------------------------------------------------
# APPLICATION DNS RECORD
#
# Creates a simple Alias record pointing to the application's load balancer.
# This assumes that an ELB/ALB will be provisioned within the EKS cluster (e.g., by an Ingress
# controller managed by Argo CD) and its details are passed into this module.
# --------------------------------------------------------------------------------------------------
resource "aws_route53_record" "app" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "app.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.app_load_balancer_dns_name
    zone_id                = var.app_load_balancer_zone_id
    evaluate_target_health = true
  }
}