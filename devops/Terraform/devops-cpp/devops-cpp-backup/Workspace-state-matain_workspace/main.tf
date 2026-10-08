# All VPC, Subnets, ALB, ASG, Route Tables, NAT Gateway resources are managed by the module
module "ec2_vpc_infrastructure" {
  source = "./module/Ec2_vpc_sunets_nat_security"

  vpc_cretion                     = var.vpc_cretion
  cidr_blocks                     = var.cidr_blocks
  enable_dns_hostnames            = var.enable_dns_hostnames
  iam_ec2_cretion                 = var.iam_ec2_cretion
  instance_type                   = lookup(var.instance_type, terraform.workspace, "t2.micro")
  subnets_id                      = []
  igw_creation                    = "igw-demo"
  aws_route_table                 = "route-table-demo"
  target_groups                   = "app-target-group"
  security_groups_public_subnets  = []
  security_groups_public_alb      = []
  security_groups_private_subnets = ["10.0.10.0/24", "10.0.11.0/2"]
  auto_scalling_group             = var.auto_scalling_group
  environment                     = var.environment
  nat_gateway                     = "nat-gateway"
  availability_zones              = []
  public_subnet_cidrs             = var.public_subnet_cidrs
  private_subnet_cidrs            = var.private_subnet_cidrs
  enable_nat_gateway              = var.enable_nat_gateway

# adding the look ups here so that values at where i am working it perform


  aws_ec2_instnce                 = lookup(var.instance_type, terraform.workspace, "t2.micro")
  allowed_ssh_cidrs               = var.allowed_ssh_cidrs
}