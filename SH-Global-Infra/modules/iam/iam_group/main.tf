resource "aws_iam_group" "this" {
  for_each = var.groups
  name = each.key
}

# Attach the main access policy (admin_dev, devops_dev, developer_dev)
resource "aws_iam_group_policy_attachment" "policy_attach" {
  for_each = var.groups

  group = aws_iam_group.this[each.key].name
  policy_arn = each.value.policy_arn
}

# Add inline policy that allows users in this group to assume their matching role
resource "aws_iam_group_policy" "assume_role_policy" {
  for_each = var.groups

  name = "${each.key}-assume-role"
  group = aws_iam_group.this[each.key].name

  policy = jsondecode({
    version = "2012-10-17"
    Statement = [
        {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Resource = each.value.role_arn
        }
    ]
  })
}