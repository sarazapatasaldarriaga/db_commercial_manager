# outputs.tf (root)

output "vpc_id" {
  description = "The ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = module.vpc.private_subnet_ids
}


output "rds_port" {
  description = "The port for the RDS instance"
  value       = module.rds.rds_port
}

output "rds_address" {
  description = "The address of the RDS instance (private IP if not publicly accessible)"
  value       = module.rds.rds_address
}

output "rds_security_group_id" {
  description = "The ID of the RDS security group"
  value       = module.rds.rds_security_group_id
}

output "ec2_bastion_instance_id" {
  description = "The ID of the EC2 bastion instance"
  value       = aws_instance.commercial_manager_db_init_ec2.id
}

output "ec2_public_ip" {
  description = "The public IP address of the EC2 instance for DB initialization"
  value       = aws_instance.commercial_manager_db_init_ec2.public_ip
}