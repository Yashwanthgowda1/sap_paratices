output "vpc_id" {
  description = "VPC ID from module"
  value       = try(module.ec2_vpc_infrastructure.vpc_id, "")
}

output "vpc_cidr_block" {
  description = "VPC CIDR Block"
  value       = var.cidr_blocks
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = try(module.ec2_vpc_infrastructure.public_subnet_ids, [])
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = try(module.ec2_vpc_infrastructure.private_subnet_ids, [])
}
