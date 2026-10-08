variable "vpc_cretion" {
  description = "VPC name"
  type        = string
  default     = "vpc-demo"
}

variable "cidr_blocks" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in VPC"
  type        = bool
  default     = true
}

variable "iam_ec2_cretion" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-02b8269d5e85954ef"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "allowed_ssh_cidrs" {
  description = "Allowed public IPs for SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway"
  type        = bool
  default     = true
}

variable "environment" {
  description = "Environment mapping"
  type        = map(string)
  default = {
    dev = "development"
  }

}
variable "auto_scalling_group" {
  description = "auto scalling  groups"
  type = map(string)
    default = {
        min_size         = "2"
        max_size         = "3"
        desired_capacity = "2"
}
}


