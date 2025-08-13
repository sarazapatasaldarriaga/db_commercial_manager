# outputs.tf for RDS module

output "rds_endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = aws_db_instance.commercial_manager_mysql_db.endpoint
}

output "rds_port" {
  description = "The port for the RDS instance"
  value       = aws_db_instance.commercial_manager_mysql_db.port
}

output "rds_address" {
  description = "The address of the RDS instance (private IP if not publicly accessible)"
  value       = aws_db_instance.commercial_manager_mysql_db.address
}

output "rds_security_group_id" {
  description = "The ID of the RDS security group"
  value       = aws_security_group.commercial_manager_rds_sg.id
}