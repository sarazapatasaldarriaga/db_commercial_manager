# outputs.tf for VPC module

output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.commercial_manager_vpc.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = [aws_subnet.commercial_manager_public_subnet_a.id, aws_subnet.commercial_manager_public_subnet_b.id]
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = [aws_subnet.commercial_manager_private_subnet_a.id, aws_subnet.commercial_manager_private_subnet_b.id]
}

output "public_route_table_ids" {
  description = "The IDs of the public route tables"
  value       = [aws_route_table.commercial_manager_public_rt_a.id, aws_route_table.commercial_manager_public_rt_b.id]
}

output "private_route_table_ids" {
  description = "The IDs of the private route tables"
  value       = [aws_route_table.commercial_manager_private_rt_a.id, aws_route_table.commercial_manager_private_rt_b.id]
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.commercial_manager_vpc.cidr_block
}