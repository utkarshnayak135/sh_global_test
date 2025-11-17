resource "aws_iam_role" "this" {
    for_each = var.roles

    name = each.key
    assume_role_policy = jsondecode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Principal = {
                AWS = "*"
            }
            Action = "sts:AssumeRole"
        }]
    })
  
}

resource "aws_iam_role_policy_attachment" "attach" {
    for_each = var.roles

    role = aws_iam_role.this[each.key].name
    policy_arn = each.value.policy_arn 
}