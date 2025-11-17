variable "groups" {
  type = map(object({
    policy_arn = string
    role_arn = string
  }))
  description = "Map of IAM groups with their policy ARN and assume role ARN"
}