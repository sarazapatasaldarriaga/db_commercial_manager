# # AWS region for deployment.
# # Default: "us-east-2"
# aws_region = "us-east-2"

# ------------------------------------------------------------------------------
# Database (RDS) Configuration
# ------------------------------------------------------------------------------

# # Unique identifier for the RDS DB instance.
# # Default: "commercial-manager"
# db_instance_identifier = "commercial-manager"

# # Name of the database to create.
# # Default: "commercial_manager"
# db_name = "commercial_manager"

# # Master username for the database.
# # Default: "admin"
# db_username = "admin"

# # (Required) Master password for the database. This is a sensitive value.
# # No default value is provided for security reasons. You must set this.
# db_password = "YourSecurePassword"

# # Allocated storage for the database in GB.
# # Default: 20
# db_allocated_storage = 20

# # DB instance class for the database.
# # Default: "db.t3.micro"
# db_instance_class = "db.t3.micro"

# # MySQL engine version for the database.
# # Default: "8.0"
# db_engine_version = "8.0"

# ------------------------------------------------------------------------------
# EC2 Instance Configuration
# ------------------------------------------------------------------------------

# # AMI ID for the EC2 instance.
# # Default: "ami-0169aa51f6faf20d5" (Latest Amazon Linux 2023 for us-east-2)
# ec2_ami_id = "ami-0169aa51f6faf20d5"

# # Instance type for the EC2 instance.
# # Default: "t3.micro"
# ec2_instance_type = "t3.micro"
