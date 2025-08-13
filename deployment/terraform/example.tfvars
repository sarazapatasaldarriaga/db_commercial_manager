# example.tfvars
# This file contains example values for the Terraform variables.
# Copy this file to 'terraform.tfvars' and fill in your actual values.

aws_region = "us-east-1"
vpc_cidr = "10.0.0.0/16"
public_subnet_cidr_a = "10.0.1.0/24"
public_subnet_cidr_b = "10.0.3.0/24"
private_subnet_cidr_a = "10.0.2.0/24"
private_subnet_cidr_b = "10.0.4.0/24"
db_instance_identifier = "commercial-manager-mysql-db"
db_name = "commercialmanagerdb"
db_username = "admin"
db_password = "your_secure_db_password" # IMPORTANT: Change this to a strong, unique password
db_allocated_storage = 20
db_instance_class = "db.t3.micro"
db_engine_version = "8.0"

ec2_ami_id = "ami-053b0d53c279acc90" # Example: Ubuntu Server 22.04 LTS (HVM), SSD Volume Type
ec2_instance_type = "t3.micro"