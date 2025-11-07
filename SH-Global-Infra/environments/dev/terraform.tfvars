aws_region       = "eu-west-1"
environment      = "dev"
project_name     = "SH"
vpc_cidr         = "10.0.0.0/16"
public_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
availability_zones = ["eu-west-1a", "eu-west-1b"]
domain_name      = "dev.sh.example.com"

# --- Sensitive variables - replace with actual values ---
# It is strongly recommended to manage these secrets using a service like AWS Secrets Manager
# and reference them using data sources instead of hardcoding them in a .tfvars file.
db_username = "YOUR_DATABASE_USERNAME"
db_password = "YOUR_DATABASE_PASSWORD"