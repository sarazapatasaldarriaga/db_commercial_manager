output "rds_port" {
  description = "The port for the RDS instance"
  value       = module.rds.rds_port
}

output "rds_address" {
  description = "The address of the RDS instance"
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
