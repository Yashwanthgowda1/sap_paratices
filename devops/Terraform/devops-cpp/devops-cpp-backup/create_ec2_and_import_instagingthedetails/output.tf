output "public_ip" {
  description = "EC2 Public IP"
  value       = module.aws_ec2_instnce.aws_public_ips
}