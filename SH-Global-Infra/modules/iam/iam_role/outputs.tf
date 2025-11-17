output "role_arns" {
    value = { for k, v in aws_aws_iam_role.this : k => v.arn }  
}