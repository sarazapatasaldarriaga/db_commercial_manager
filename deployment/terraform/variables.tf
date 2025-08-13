# variables.tf (root)

variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_a" {
  description = "CIDR block for the first public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_cidr_b" {
  description = "CIDR block for the second public subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet_cidr_a" {
  description = "CIDR block for the first private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_cidr_b" {
  description = "CIDR block for the second private subnet"
  type        = string
  default     = "10.0.4.0/24"
}

variable "db_instance_identifier" {
  description = "Unique identifier for the RDS DB instance"
  type        = string
  default     = "commercial-manager-mysql-db"
}

variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "commercialmanagerdb"
}

variable "db_username" {
  description = "Master username for the database"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true
}

variable "db_allocated_storage" {
  description = "Allocated storage for the database (GB)"
  type        = number
  default     = 20
}

variable "db_instance_class" {
  description = "DB instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_engine_version" {
  description = "DB engine version"
  type        = string
  default     = "8.0"
}

variable "ec2_ami_id" {
  description = "AMI ID for the EC2 instance (e.g., Amazon Linux 2)"
  type        = string
  default     = "ami-0169aa51f6faf20d5" # Latest Amazon Linux 2 AMI for us-east-1
}

variable "ec2_instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
  default     = "t3.micro"
}
