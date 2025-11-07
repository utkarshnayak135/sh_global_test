# --------------------------------------------------------------------------------------------------
# DB SUBNET GROUP
# --------------------------------------------------------------------------------------------------
resource "aws_db_subnet_group" "default" {
  name       = "${var.project_name}-${var.environment}-aurora-sng"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name        = "${var.project_name}-aurora-sng"
    Project     = var.project_name
    Environment = var.environment
  }
}

# --------------------------------------------------------------------------------------------------
# SECURITY GROUP
# --------------------------------------------------------------------------------------------------
resource "aws_security_group" "aurora" {
  name        = "${var.project_name}-${var.environment}-aurora-sg"
  description = "Controls access to the Aurora PostgreSQL cluster"
  vpc_id      = var.vpc_id

  # Allow PostgreSQL traffic from within the same VPC
  ingress {
    description = "PostgreSQL from VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Adjust this to be more specific if needed, e.g., from EKS SG
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-aurora-sg"
    Project     = var.project_name
    Environment = var.environment
  }
}

# --------------------------------------------------------------------------------------------------
# AURORA CLUSTER
# --------------------------------------------------------------------------------------------------
resource "aws_rds_cluster" "default" {
  cluster_identifier      = "${var.project_name}-${var.environment}-aurora-cluster"
  engine                  = "aurora-postgresql"
  engine_version          = "13.7"
  availability_zones      = slice(var.private_subnet_ids, 0, var.cluster_size) # Use AZs of the provided subnets
  database_name           = "${var.project_name}db"
  master_username         = var.db_username
  master_password         = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.default.name
  vpc_security_group_ids  = [aws_security_group.aurora.id]
  skip_final_snapshot     = true
  storage_encrypted       = true

  tags = {
    Name        = "${var.project_name}-aurora-cluster"
    Project     = var.project_name
    Environment = var.environment
  }
}

# --------------------------------------------------------------------------------------------------
# AURORA CLUSTER INSTANCES
# --------------------------------------------------------------------------------------------------
resource "aws_rds_cluster_instance" "default" {
  count              = var.cluster_size
  identifier         = "${var.project_name}-${var.environment}-aurora-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.default.id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.default.engine
  engine_version     = aws_rds_cluster.default.engine_version

  tags = {
    Name        = "${var.project_name}-aurora-instance-${count.index}"
    Project     = var.project_name
    Environment = var.environment
  }
}