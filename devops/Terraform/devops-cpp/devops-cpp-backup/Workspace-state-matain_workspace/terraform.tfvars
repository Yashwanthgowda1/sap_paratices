# -----------------------
# ENVIRONMENT
# -----------------------
environment = {
  dev = "dev"
}

# -----------------------
# VPC
# -----------------------
vpc_cretion            = "vpc_demo_dev"
cidr_blocks            = "10.0.0.0/16"
enable_dns_hostnames   = true

# -----------------------
# EC2
# -----------------------
iam_ec2_cretion = "ami-0ebf411a80b6b22cb"   # Ubuntu 22.04 (example)
# instance_type   = "t3.micro"

# -----------------------
# SSH ACCESS (YOUR LAPTOP PUBLIC IP)
# Replace with your real public IP
# -----------------------
allowed_ssh_cidrs = [
  "4.240.39.192/32"
]

# -----------------------
# AUTOSCALING
# -----------------------

