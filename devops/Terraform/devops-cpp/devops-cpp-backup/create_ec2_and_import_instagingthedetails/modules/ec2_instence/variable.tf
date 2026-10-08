variable "name_of_instence" {
    description = "my first ec2 instnce and prividing the "
    type = string
    default = "first-ec2"
}
variable "ami_values" {
    description = "privoid type of machin use"
    type = string
}
# variable "security_group" {
#   description = "Name or ID of the security group"
#   type        = list(string)
#   default = ["sg-088a3fac0f7b0d4d4"]
# }
variable "key_pairs" {
    type = string
    default = "new_demo1"
  
}
variable "aws_region" {
    description = "first select the ergion"
    type = string
    default = "us-east-1"  
}
variable "publicips-enable"{
    description = "enable the public ips"
    type = string
    default = "enable"
}
variable "instance_type" {
    description = "instnce need to give"

  
}