variable "aws_ec2_name" {
    type = string
    default = "ec2_first_name"
}
  


  

variable "key_pairs" {
    type = string
    default = "new_demo1"
  
}
variable "instance_type" {
    type = string
  
}
variable "aws_ami_values" {
    type=string
    default ="ami-00f46ccd1cbfb363e" 
  }
# variable "security_group_values" {
#     type = list(string)
#     default = [""]

# }
variable "aws_region" {
    type = string
    default = "us-east-1"
  
}
# variable "security_group" {
#   description = "Security group name or ID"
#   type        = list(string)
#   default = ["sg-088a3fac0f7b0d4d4"]
# }

variable "name_of_instence" {
  description = "Name of the EC2 instance"
  type        = string
  default = "fist_level"
}
