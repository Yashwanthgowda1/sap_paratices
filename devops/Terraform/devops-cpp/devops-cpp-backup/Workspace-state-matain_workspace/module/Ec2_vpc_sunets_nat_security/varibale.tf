
variable "vpc_cretion" {
    description = "the vpc cretaion at the architecture"
    default= "vpc_demo_project"
}
variable "iam_ec2_cretion" {
   description = "List of public IPs allowed to SSH into bastion host"
   type        = string
  
}
variable "instance_type" {
  description = "specify_the instnce"
  default = "t3.micro"
  
}
variable "cidr_blocks" {
    description = "the cidr blocks for vpc"
    default= "10.0.0.0/16"
}
variable "enable_dns_hostnames" {
    description = "Enable DNS hostnames in the VPC"
    default     = true
}
variable "subnets_id" {
    description = "cretion two sunets in vpc"
 
}
variable "igw_creation" {
    description = "creation of internet gateway for vpc"
    default= "igw_demo_project" 
}
variable "aws_route_table" {
    description = "creation of route table for vpc"
    default= "route_table_demo_project"
  
}
variable "target_groups"{
    description = "target group for  nat gateway"
}
variable "auto_scalling_group" {
  description = "auto scalling  groups"
    type = object({
    min_size         = number
    max_size         = number
    desired_capacity = number
  })

  default = {
    min_size         = 2
    max_size         = 3
    desired_capacity = 2
  }

}
variable "security_groups_public_subnets" {
  description = "Security group IDs for public subnets"
  type        = list(string)
}

variable "security_groups_public_alb" {
  description = "Security group IDs for public ALB"
  type        = list(string)
}

variable "security_groups_private_subnets" {
  description = "Security group IDs for private subnets"
  type        = list(string)
}

variable "environment" {
    description = "Environment tag for resources"
    type = map(string)
    default = {
        dev        = "development"
        prod       = "production"
        stage      = "staging"
}
}
variable "nat_gateway" {
    description = "allocation0f nat ectrenal word connect"
    type = string
}
variable "availability_zones" {
  description = "Availability zones for subnets"
  type        = list(string)
}
 
variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}
variable "enable_nat_gateway" {
  type    = bool
  default = true
}

variable "aws_ec2_instnce" {
    description = "ec2 instnce cretion in baston host"
    type = string
}
variable "allowed_ssh_cidrs" {
  description = "List of public IPs allowed to SSH into bastion host"
  type        = list(string)
}
