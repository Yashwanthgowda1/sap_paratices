# devops-cpp

first call the :  terraform init  
1) first it will check the state file in local if present or it call from backend of terrform ex: aws s3 or azure storage etc
2) .tfvar file where used to genarrly pass the value uniqely

3) module concept where we can pass : values in Main.tf  --> taking the refence of moudel name


4)  terraform plan : it will give the configuartion setup things befor apply


curl ifconfig.me



so... here the varible at root lvele explain the main.tf module at the root level refernce and type and default values specify  or pass through the .tfvars


workspace:
so that matin stage file each stage avoid the override the state file
tree
terraform workspace select dev



#####  once it is genrated 
terraform import \
  -generate-config-out=generated_ec2.tf \
  aws_instance.cft_tf \
  i-011bb41a1f5a7ff81
