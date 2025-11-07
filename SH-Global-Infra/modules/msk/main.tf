# --------------------------------------------------------------------------------------------------
# SECURITY GROUP
# --------------------------------------------------------------------------------------------------
resource "aws_security_group" "msk" {
  name        = "${var.project_name}-${var.environment}-msk-sg"
  description = "Controls access to the MSK Kafka cluster"
  vpc_id      = var.vpc_id

  # Allow all Kafka traffic from the EKS cluster security group
  ingress {
    description     = "Kafka traffic from EKS"
    from_port       = 0
    to_port         = 9094 # For PLAINTEXT and TLS
    protocol        = "tcp"
    security_groups = [var.eks_cluster_sg_id]
  }

  # Allow all traffic between brokers within the same security group
  ingress {
    description = "Intra-broker communication"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-msk-sg"
    Project     = var.project_name
    Environment = var.environment
  }
}

# --------------------------------------------------------------------------------------------------
# MSK CLUSTER
# --------------------------------------------------------------------------------------------------
resource "aws_msk_cluster" "default" {
  cluster_name           = "${var.project_name}-${var.environment}-msk-cluster"
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.number_of_broker_nodes

  broker_node_group_info {
    instance_type          = var.broker_node_instance_type
    client_subnets         = var.private_subnet_ids
    security_groups        = [aws_security_group.msk.id]
    ebs_volume_size        = 100
  }

  encryption_info {
    encryption_in_transit {
      client_broker = "TLS_PLAINTEXT"
      in_cluster    = true
    }
  }

  tags = {
    Name        = "${var.project_name}-msk-cluster"
    Project     = var.project_name
    Environment = var.environment
  }
}