output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Public Subnet IDs"
  value       = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  description = "Private Subnet IDs"
  value       = aws_subnet.private_subnets[*].id
}

output "vpc_creation_name" {
  description = "VPC creation name"
  value       = var.vpc_cretion
}

output "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  value       = var.cidr_blocks
}

output "dns_hostnames_enabled" {
  description = "DNS hostnames status"
  value       = var.enable_dns_hostnames
}

output "subnets_ids" {
  description = "Subnet IDs used in the VPC"
  value       = var.subnets_id
}

output "internet_gateway_name" {
  description = "Internet Gateway name"
  value       = var.igw_creation
}

output "route_table_name" {
  description = "Route table name"
  value       = var.aws_route_table
}

output "target_groups" {
  description = "Target groups for NAT Gateway"
  value       = var.target_groups
}

output "auto_scaling_group_config" {
  description = "Auto Scaling Group configuration"
  value       = var.auto_scalling_group
}

output "security_groups_private_subnets" {
  description = "Security groups for the VPC"
  value       = var.security_groups_private_subnets
}
output "security_groups_public_subnets" {
  description = "Security groups for the VPC"
  value       = var.security_groups_public_subnets
}

output "environment_tags" {
  description = "Environment tags"
  value       = var.environment
}

output "nat_gateway_allocation" {
  description = "NAT Gateway allocation"
  value       = var.nat_gateway
}
