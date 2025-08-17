# variables.tf for RDS module

variable "private_subnet_ids" {
  description = "The IDs of the private subnets"
  type        = list(string)
}

variable "ec2_security_group_id" {
  description = "The ID of the EC2 security group that needs to access RDS"
  type        = string
}

variable "db_instance_identifier" {
  description = "Unique identifier for the RDS DB instance"
  type        = string
}

variable "db_name" {
  description = "Name of the database"
  type        = string
}

variable "db_username" {
  description = "Master username for the database"
  type        = string
}

variable "db_password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true
}

variable "db_allocated_storage" {
  description = "Allocated storage for the database (GB)"
  type        = number
}

variable "db_instance_class" {
  description = "DB instance class"
  type        = string
}

variable "db_engine_version" {
  description = "DB engine version"
  type        = string
}
