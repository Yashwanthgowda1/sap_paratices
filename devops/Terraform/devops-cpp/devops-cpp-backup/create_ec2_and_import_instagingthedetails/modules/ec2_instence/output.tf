output "aws_public_ips" {
  value = aws_instance.creation.public_ip
  
}
