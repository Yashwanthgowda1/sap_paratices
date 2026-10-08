data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "main" {
  cidr_block           = var.cidr_blocks
  instance_tenancy     = "default"
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name        = var.vpc_cretion
    Environment = var.environment["dev"]
  }
}
resource "aws_subnet" "public_subnets" {
  vpc_id     = aws_vpc.main.id

  count = 2
  cidr_block = cidrsubnet(var.cidr_blocks, 8, count.index+1)
   
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.environment["dev"]}-${count.index +1}"
    Type ="public"
  }
}
resource "aws_subnet" "private_subnets" {
  vpc_id     = aws_vpc.main.id

  count = 2
  cidr_block = cidrsubnet(var.cidr_blocks, 8, count.index+10)
  availability_zone = data.aws_availability_zones.available.names[count.index]
   
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.environment["dev"]}-${count.index +1}"
    Type = "private"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment["dev"]}"
  }
}

# resource "aws_placement_group" "test" {
#   name     = "test"
#   strategy = "cluster"
# }


resource "aws_lb_target_group" "app_tg" {
  name     = "app-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id  = aws_vpc.main.id

  health_check {
    path                = "/"
    port                = "8080"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "app-target-group"
  }
}

resource "aws_security_group" "alb_sg" {
  name   = "security-group-for-autoscalling"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_lb" "app_alb" {
  name               = "load-balancer-from80"
  load_balancer_type = "application"
  internal           = false

  subnets         = aws_subnet.public_subnets[*].id
  security_groups = [aws_security_group.alb_sg.id]

  tags = {
    Name = "load balancer from security group allow 80"
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

#-------------------------------
# aws_lanuch templete and auto csaling group   and security group

# ----------------------------------------------
resource "aws_security_group" "bastion_sg" {
  name   = "bastion-ssh-sg"
  vpc_id = aws_vpc.main.id

  # SSH from YOUR laptop only
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-security-group"
  }
}

resource "aws_instance" "aws_baston_communicate_private_ips" {
  ami           = var.iam_ec2_cretion
  instance_type = var.instance_type
  key_name = "new-demo11"
  subnet_id = aws_subnet.public_subnets[0].id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
 
  tags = {
      name="baston_host_+communication"
   }
  
}
resource "aws_security_group" "private_ec2_sg" {
  name   = "private-ec2-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_launch_template" "private_lt" {
  name_prefix   = "private-asg-lt-"
  image_id      =   var.iam_ec2_cretion
  instance_type = var.instance_type
  key_name      = "new-demo11"

  vpc_security_group_ids = [
    aws_security_group.private_ec2_sg.id
  ]
# provisong cannot use because it is not constenet ec2 private subnets 
  user_data = base64encode(<<-EOF
    #!/bin/bash
    apt update -y
    apt install -y apache2
    sed -i 's/80/8080/g' /etc/apache2/ports.conf
    sed -i 's/80/8080/g' /etc/apache2/sites-enabled/000-default.conf
    systemctl restart apache2
    systemctl enable apache2
  EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "private-asg-instance"
    }
  }
}
resource "aws_autoscaling_group" "private_asg" {
  name                      = "private-asg"
  min_size                  = 2
  max_size                  = 5
  desired_capacity          = 2
  health_check_type         = "ELB"
  health_check_grace_period = 300

  vpc_zone_identifier = aws_subnet.private_subnets[*].id
  target_group_arns   = [aws_lb_target_group.app_tg.arn]

  launch_template {
    id      = aws_launch_template.private_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Environment"
    value               = var.environment["dev"]
    propagate_at_launch = true
  }
}

# -----------------------------------
# adding the route table acrray the intrent traffic
# -----------------------------------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.environment["dev"]}-public-rt"
  }
}
resource "aws_route_table_association" "public_rt_assoc" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}
# --------------------------------------
# nat gateway for private ips intrent communication
# ---------------------------------------------------

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "${var.environment["dev"]}-nat-eip"
  }
}
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name = "${var.environment["dev"]}-nat-gateway"
  }

  depends_on = [aws_internet_gateway.gw]
}

# ------------------------------------------------
# private route table
# -------------------------------------------------------
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "${var.environment["dev"]}-private-rt"
  }
}
resource "aws_route_table_association" "private_rt_assoc" {
  count          = length(aws_subnet.private_subnets)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_rt.id
}





