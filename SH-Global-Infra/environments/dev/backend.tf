terraform {
  backend "s3" {
    bucket         = "sh-dev-terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "sh-dev-terraform-state-lock"
    encrypt        = true
  }
}