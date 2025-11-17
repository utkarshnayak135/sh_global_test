output "policy_arns" {
    value = merge(
        { for k, v in aws_iam_policy.custom : k => v.arn},
        local.managed_policies
    )
}