# ------------------------------------------------------------------------------------------------
# AWS and Networking Configuration
# ------------------------------------------------------------------------------------------------

# # (Required) AWS region for deployment.
# # Default: "us-east-2"
# aws_region = "us-east-2"

# # (Required) CIDR block for the VPC.
# # Default: "10.0.0.0/16"
# vpc_cidr = "10.0.0.0/16"

# # (Required) CIDR block for the first public subnet.
# # Default: "10.0.1.0/24"
# public_subnet_cidr_a = "10.0.1.0/24"

# # (Required) CIDR block for the second public subnet.
# # Default: "10.0.3.0/24"
# public_subnet_cidr_b = "10.0.3.0/24"

# # (Required) CIDR block for the first private subnet.
# # Default: "10.0.2.0/24"
# private_subnet_cidr_a = "10.0.2.0/24"

# # (Required) CIDR block for the second private subnet.
# # Default: "10.0.4.0/24"
# private_subnet_cidr_b = "10.0.4.0/24"


# ------------------------------------------------------------------------------------------------
# Database (RDS) Configuration
# ------------------------------------------------------------------------------------------------

# # (Required) Unique identifier for the RDS DB instance.
# # Default: "commercial-manager-mysql-db"
# db_instance_identifier = "commercial-manager-mysql-db"

# # (Required) Name of the database to create.
# # Default: "commercialmanagerdb"
# db_name = "commercialmanagerdb"

# # (Required) Master username for the database.
# # Default: "admin"
# db_username = "admin"

# # (Required) Master password for the database. This is a sensitive value.
# # No default value is provided for security reasons. You must set this.
# db_password = "YourSecurePassword"

# # (Required) Allocated storage for the database in GB.
# # Default: 20
# db_allocated_storage = 20

# # (Required) DB instance class for the database.
# # Default: "db.t3.micro"
# db_instance_class = "db.t3.micro"

# # (Required) DB engine version for the database.
# # Default: "8.0"
# db_engine_version = "8.0"

# # (Optional) Name of the DB parameter group.
# # Default: "default.mysql8.0"
# db_parameter_group_name = "default.mysql8.0"


# ------------------------------------------------------------------------------------------------
# EC2 Instance Configuration
# ------------------------------------------------------------------------------------------------

# # (Required) AMI ID for the EC2 instance.
# # Default: "ami-0169aa51f6faf20d5" (Latest Amazon Linux 2023 for us-east-2)
# ec2_ami_id = "ami-0169aa51f6faf20d5"

# # (Required) Instance type for the EC2 instance.
# # Default: "t3.micro"
# ec2_instance_type = "t3.micro"
