resource "aws_iam_policy" "custom" {
  for_each = var.custom_policies

  name = each.key
  description = "Custom IAM policy for ${each.key} group"
  policy = file("${path.module}/policies/${each.value}")
}

locals {
  managed_policies = var.managed_policies
}