module "aws_ec2_instnce" {
    source = "./modules/ec2_instence"
   
    ami_values = var.aws_ami_values

    # security_group =var.security_group
    key_pairs = var.key_pairs
    instance_type = var.instance_type
}