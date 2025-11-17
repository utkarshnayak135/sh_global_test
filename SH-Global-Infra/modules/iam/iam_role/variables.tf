variable "roles" {
    type = map(object({
        policy_arn = string
    }))
  description = "Map of IAM roles and their attached policy ARNs"
}