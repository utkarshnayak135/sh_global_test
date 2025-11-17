variable "custom_policies" {
  type = map(string)
  description = "Mapping of custom policy names to JSON file names"
  default = {}
}

variable "managed_policies" {
    type = map(string)
    description = "Mapping of policy names to AWS-managed policy ARNs"
    default = {}
}