# variables.tf for VPC module

variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr_a" {
  description = "CIDR block for the first public subnet"
  type        = string
}

variable "public_subnet_cidr_b" {
  description = "CIDR block for the second public subnet"
  type        = string
}

variable "private_subnet_cidr_a" {
  description = "CIDR block for the first private subnet"
  type        = string
}

variable "private_subnet_cidr_b" {
  description = "CIDR block for the second private subnet"
  type        = string
}