# main.tf for RDS module

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "commercial_manager_rds_sg" {
  name        = "commercial-manager-rds-sg"
  description = "Allow MySQL access from within the VPC and from the EC2 initialization instance"
  vpc_id      = data.aws_vpc.default.id

  # ingress {
  #   from_port   = 3306
  #   to_port     = 3306
  #   protocol    = "tcp"
  #   security_groups = [var.ec2_security_group_id] # Allow access from the EC2 instance
  # }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block] # Allow access from anywhere within the VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "commercial-manager-rds-sg"
  }
}

resource "aws_security_group_rule" "allow_ec2_to_rds" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = var.ec2_security_group_id
  security_group_id        = aws_security_group.commercial_manager_rds_sg.id
  description              = "Allow MySQL access from the EC2 instance"
}

resource "aws_db_subnet_group" "commercial_manager_db_subnet_group" {
  name       = "commercial-manager-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "commercial-manager-db-subnet-group"
  }
}

resource "aws_db_instance" "commercial_manager_mysql_db" {
  allocated_storage    = var.db_allocated_storage
  db_name              = var.db_name
  engine               = "mysql"
  engine_version       = var.db_engine_version
  instance_class       = var.db_instance_class
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  publicly_accessible  = false # Keep it private
  vpc_security_group_ids = [aws_security_group.commercial_manager_rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.commercial_manager_db_subnet_group.name
  identifier           = var.db_instance_identifier

  tags = {
    Name = "commercial-manager-mysql-db"
  }
}