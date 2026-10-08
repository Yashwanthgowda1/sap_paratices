provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "creation" {
    ami = var.ami_values
   
    key_name = var.key_pairs
    instance_type = var.instance_type
    tags = {
      name=var.name_of_instence
    }
  
}