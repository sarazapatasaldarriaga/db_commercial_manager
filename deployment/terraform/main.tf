# main.tf (root)

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"

  aws_region           = var.aws_region
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidr_a = var.public_subnet_cidr_a
  public_subnet_cidr_b = var.public_subnet_cidr_b
  private_subnet_cidr_a = var.private_subnet_cidr_a
  private_subnet_cidr_b = var.private_subnet_cidr_b
}

# EC2 Security Group for SSH and MySQL client
resource "aws_security_group" "commercial_manager_ec2_sg" {
  name        = "commercial-manager-ec2-sg"
  description = "Allow SSH and outbound MySQL access"
  vpc_id      = module.vpc.vpc_id

  

  # egress {
  #   from_port   = 3306
  #   to_port     = 3306
  #   protocol    = "tcp"
  #   security_groups = [module.rds.rds_security_group_id] # Allow outbound MySQL access to RDS
  # }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    self        = true
    description = "Allow instance to communicate with VPC endpoints"
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr] # Allow outbound HTTPS to SSM VPC Endpoints
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic for other purposes (e.g., S3 access)"
  }

  tags = {
    Name = "commercial-manager-ec2-sg"
  }
}

resource "aws_security_group_rule" "allow_rds_from_ec2" {
  type                     = "egress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.rds.rds_security_group_id
  security_group_id        = aws_security_group.commercial_manager_ec2_sg.id
  description              = "Allow outbound MySQL access to RDS"
}

module "rds" {
  source = "./modules/rds"

  vpc_id                 = module.vpc.vpc_id
  vpc_cidr               = var.vpc_cidr
  private_subnet_ids     = module.vpc.private_subnet_ids
  ec2_security_group_id  = aws_security_group.commercial_manager_ec2_sg.id
  db_instance_identifier = var.db_instance_identifier
  db_name                = var.db_name
  db_username            = var.db_username
  db_password            = var.db_password
  db_allocated_storage   = var.db_allocated_storage
  db_instance_class      = var.db_instance_class
  db_engine_version      = var.db_engine_version
}

# S3 Bucket for SQL scripts
resource "aws_s3_bucket" "commercial_manager_sql_scripts" {
  bucket = "commercial-manager-sql-scripts-${data.aws_caller_identity.current.account_id}"
  force_destroy = true

  tags = {
    Name = "commercial-manager-sql-scripts"
  }
}

# Upload DDL and DML scripts to S3
resource "null_resource" "upload_sql_scripts" {
  depends_on = [aws_s3_bucket.commercial_manager_sql_scripts]

  provisioner "local-exec" {
    command = <<EOT
      aws s3 cp ./modules/rds/sql_scripts/schema.sql s3://${aws_s3_bucket.commercial_manager_sql_scripts.id}/schema.sql
      aws s3 cp ./modules/rds/sql_scripts/data.sql s3://${aws_s3_bucket.commercial_manager_sql_scripts.id}/data.sql
    EOT
    interpreter = ["bash", "-c"]
  }
}

# IAM Role for EC2 to access S3 and SSM
resource "aws_iam_role" "ec2_s3_ssm_access_role" {
  name = "commercial-manager-ec2-s3-ssm-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "commercial-manager-ec2-s3-ssm-access-role"
  }
}

resource "aws_iam_role_policy_attachment" "ec2_s3_access_policy_attach" {
  role       = aws_iam_role.ec2_s3_ssm_access_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "ec2_ssm_managed_instance_core_policy_attach" {
  role       = aws_iam_role.ec2_s3_ssm_access_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_s3_ssm_access_profile" {
  name = "commercial-manager-ec2-s3-ssm-access-profile"
  role = aws_iam_role.ec2_s3_ssm_access_role.name
}

# EC2 Instance for DB initialization
resource "aws_instance" "commercial_manager_db_init_ec2" {
  ami           = var.ec2_ami_id
  instance_type = var.ec2_instance_type
  subnet_id     = module.vpc.public_subnet_ids[0] # Deploy in a public subnet for internet access
  vpc_security_group_ids = [aws_security_group.commercial_manager_ec2_sg.id]
  associate_public_ip_address = true # Public IP needed for internet access to install packages
  iam_instance_profile = aws_iam_instance_profile.ec2_s3_ssm_access_profile.name

  user_data = <<EOT
    #!/bin/bash
    # All setup is now handled via SSM in the null_resource below
  EOT

  tags = {
    Name = "commercial-manager-db-init-ec2"
  }

  depends_on = [module.rds, null_resource.upload_sql_scripts]
}

# VPC Endpoints for SSM
resource "aws_vpc_endpoint" "ssm_vpce" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc.private_subnet_ids
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.commercial_manager_ec2_sg.id]

  tags = {
    Name = "commercial-manager-ssm-vpce"
  }
}

resource "aws_vpc_endpoint" "ssmmessages_vpce" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc.private_subnet_ids
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.commercial_manager_ec2_sg.id]

  tags = {
    Name = "commercial-manager-ssmmessages-vpce"
  }
}

resource "aws_vpc_endpoint" "ec2messages_vpce" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc.private_subnet_ids
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.commercial_manager_ec2_sg.id]

  tags = {
    Name = "commercial-manager-ec2messages-vpce"
  }
}

# Setup EC2 instance with non-sensitive commands
resource "null_resource" "setup_ec2_instance" {
  depends_on = [aws_instance.commercial_manager_db_init_ec2]

  provisioner "local-exec" {
    command = <<EOT
      echo "Waiting for EC2 instance to be ready for SSM..."
      aws ec2 wait instance-status-ok --instance-ids ${aws_instance.commercial_manager_db_init_ec2.id}
      echo "EC2 instance is ready. Installing packages and downloading scripts via SSM..."
      COMMAND_ID=$(aws ssm send-command \
        --instance-ids ${aws_instance.commercial_manager_db_init_ec2.id} \
        --document-name AWS-RunShellScript \
        --comment "Install MariaDB client and download SQL scripts" \
        --parameters commands='["sudo dnf install -y mariadb105", "aws s3 cp s3://${aws_s3_bucket.commercial_manager_sql_scripts.id}/schema.sql /tmp/schema.sql", "aws s3 cp s3://${aws_s3_bucket.commercial_manager_sql_scripts.id}/data.sql /tmp/data.sql"]' \
        --query "Command.CommandId" --output text)
      echo "SSM Command ID for setup: $COMMAND_ID"
      echo "Waiting for setup command to complete..."
      aws ssm wait command-executed --command-id $COMMAND_ID --instance-id ${aws_instance.commercial_manager_db_init_ec2.id}
      echo "Setup command completed. Checking status and output:"
      aws ssm get-command-invocation --command-id $COMMAND_ID --instance-id ${aws_instance.commercial_manager_db_init_ec2.id} --query "StandardOutputContent" --output text
    EOT
    interpreter = ["bash", "-c"]
  }
}

# Remote-exec to run SQL scripts on EC2 (sensitive commands)
resource "null_resource" "run_sql_scripts_on_ec2" {
  depends_on = [null_resource.setup_ec2_instance]

  provisioner "local-exec" {
    command = <<EOT
      echo "Running sensitive database commands (output will be suppressed)..."
      COMMAND_ID=$(aws ssm send-command \
        --instance-ids ${aws_instance.commercial_manager_db_init_ec2.id} \
        --document-name AWS-RunShellScript \
        --comment "Run MySQL schema and data scripts" \
        --parameters commands='["until mysql -h ${module.rds.rds_address} -P ${module.rds.rds_port} -u ${var.db_username} -p${var.db_password} -e \"SELECT 1;\"; do echo \"Waiting for DB to connect...\"; sleep 5; done", "mysql -h ${module.rds.rds_address} -P ${module.rds.rds_port} -u ${var.db_username} -p${var.db_password} -e \"CREATE DATABASE IF NOT EXISTS ${var.db_name};\"", "mysql -h ${module.rds.rds_address} -P ${module.rds.rds_port} -u ${var.db_username} -p${var.db_password} -e \"CREATE USER IF NOT EXISTS ´${var.db_username}´@´%´ IDENTIFIED BY ´${var.db_password}´;\"", "mysql -h ${module.rds.rds_address} -P ${module.rds.rds_port} -u ${var.db_username} -p${var.db_password} -e \"GRANT ALL PRIVILEGES ON ${var.db_name}.* TO ´${var.db_username}´@´%´;\"", "mysql -h ${module.rds.rds_address} -P ${module.rds.rds_port} -u ${var.db_username} -p${var.db_password} ${var.db_name} < /tmp/schema.sql", "mysql -h ${module.rds.rds_address} -P ${module.rds.rds_port} -u ${var.db_username} -p${var.db_password} ${var.db_name} < /tmp/data.sql"]' \
        --query "Command.CommandId" --output text)
      echo "SSM Command ID for SQL scripts: $COMMAND_ID"
      aws ssm wait command-executed --command-id $COMMAND_ID --instance-id ${aws_instance.commercial_manager_db_init_ec2.id}
      echo "Database commands completed. Checking status..."
      # The output of this will be suppressed, but we run it anyway to check for errors.
      aws ssm get-command-invocation --command-id $COMMAND_ID --instance-id ${aws_instance.commercial_manager_db_init_ec2.id} --query "StatusDetails" --output text
    EOT
    interpreter = ["bash", "-c"]
  }
}

data "aws_caller_identity" "current" {}
