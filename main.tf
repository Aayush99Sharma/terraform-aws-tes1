
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "70ThreeTierVPC"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "ThreeTierIGW"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "PublicRouteTable"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Public Subnets
resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet1_cidr
  availability_zone       = var.az1
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet2_cidr
  availability_zone       = var.az2
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet2"
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}

# NAT Gateway for Private Subnets
resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  subnet_id     = aws_subnet.public1.id
  allocation_id = aws_eip.nat.id

  tags = {
    Name = "NATGateway"
  }
}

# Private Subnets
resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet1_cidr
  availability_zone = var.az1

  tags = {
    Name = "PrivateSubnet1"
  }
}

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet2_cidr
  availability_zone = var.az2

  tags = {
    Name = "PrivateSubnet2"
  }
}

# Create a private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "PrivateRouteTable"
  }
}

# Add a route for the NAT Gateway in the private route table
resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

# Associate private subnets with the private route table
resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "backend" {
  name   = "BackendSecurityGroup"
  vpc_id = aws_vpc.main.id

  # Ingress rules
  ingress {
    description = "Allow SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow from anywhere (adjust as needed)
  }

  ingress {
    description = "Allow HTTP for Django"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow from anywhere (adjust as needed)
  }

  # Egress rules
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "BackendSecurityGroup"
  }
}

resource "aws_instance" "backend" {
  ami                    = var.Backend_ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private1.id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.backend.id]

  tags = {
    Name = "Backend-Django-Clone"
  }
}

resource "aws_security_group" "frontend" {
  name        = "FrontendSecurityGroup"
  description = "Security group for frontend instance"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "FrontendSecurityGroup"
  }
}


resource "aws_instance" "frontend" {
  ami                    = var.Frontend_ami_id         
  instance_type          = var.instance_type   
  subnet_id              = aws_subnet.public1.id
  key_name               = var.key_name      
  vpc_security_group_ids = [aws_security_group.frontend.id]

  tags = {
    Name = "Frontend-Django-Instance"
  }
}


resource "aws_security_group" "database" {
  name        = "DatabaseSecurityGroup"
  description = "Security group for database"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict this in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DatabaseSecurityGroup"
  }
}


resource "aws_db_subnet_group" "db_subnet_group" {
  name        = "my-rds-subnet-group"
  description = "My RDS Subnet Group"
  subnet_ids  = [
    aws_subnet.private1.id,
    aws_subnet.private2.id
  ]

  tags = {
    Name = "MyRDSSubnetGroup"
  }
}


resource "aws_db_instance" "rds_instance" {
  identifier              = var.db_instance_identifier
  allocated_storage       = var.db_allocated_storage
  instance_class          = var.db_instance_class
  engine                  = "mysql"
  engine_version          = var.engine_version
  username                = var.master_username
  password                = var.master_user_password
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.database.id]
  multi_az                = var.multi_az
  availability_zone       = var.availability_zone
  db_name                 = var.db_name
  skip_final_snapshot     = true

  tags = {
    Name = "RDSInstance"
  }
}

resource "aws_security_group" "frontend_load_balancer" {
  name        = "FrontendLoadBalancerSecurityGroup"
  description = "Security group for frontend load balancer"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.frontend.id]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "FrontendLoadBalancerSecurityGroup"
  }
}

resource "aws_security_group" "backend_load_balancer" {
  name        = "BackendLoadBalancerSecurityGroup"
  description = "Security group for backend load balancer"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "BackendLoadBalancerSecurityGroup"
  }
}

resource "aws_launch_template" "frontend" {
  name = "FrontendLaunchTemplate"

  
    image_id             = var.Frontend_ami_id
    instance_type        = "t3.micro"
    key_name             = var.key_name
    network_interfaces {
      associate_public_ip_address = true
      device_index                = 0
      security_groups             = [aws_security_group.frontend.id]
    }
}

resource "aws_launch_template" "backend" {
  name = "BackendLaunchTemplate"

  
    image_id             = var.Backend_ami_id
    instance_type        = "t3.micro"
    key_name             = var.key_name
    network_interfaces {
      associate_public_ip_address = false
      device_index               = 0
      security_groups            = [aws_security_group.backend.id]
    }
}

resource "aws_lb_target_group" "frontend" {
  name     = "FrontendTargetGroup"
  protocol = "HTTP"
  port     = 80
  vpc_id   = aws_vpc.main.id
  target_type = "instance"

  health_check {
    interval = 30
    path     = "/"
  }
}

resource "aws_lb_target_group" "backend" {
  name     = "BackendTargetGroup"
  protocol = "HTTP"
  port     = 8000
  vpc_id   = aws_vpc.main.id
  target_type = "instance"

  health_check {
    interval = 30
    path     = "/"
  }
}

resource "aws_lb" "frontend" {
  name               = "FrontendALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.frontend.id]
  subnets            = [aws_subnet.public1.id, aws_subnet.public2.id]
  idle_timeout = 60
}

resource "aws_lb" "backend" {
  name               = "BackendALB"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.backend.id]
  subnets            = [aws_subnet.private1.id, aws_subnet.private2.id]
  idle_timeout = 60

}

resource "aws_lb_listener" "frontend" {
  load_balancer_arn = aws_lb.frontend.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
}

resource "aws_lb_listener" "backend" {
  load_balancer_arn = aws_lb.backend.arn
  port              = 8000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }
}

resource "aws_autoscaling_group" "frontend" {
  name = "FrontendASG"

  launch_template {
    id      = aws_launch_template.frontend.id
    version = "$Latest"
  }

  min_size          = 1
  max_size          = 3
  desired_capacity  = 1
  vpc_zone_identifier = [aws_subnet.public1.id, aws_subnet.public2.id]

  target_group_arns = [aws_lb_target_group.frontend.arn]

  health_check_type          = "ELB"
  health_check_grace_period  = 300

  tag {
    key                 = "Name"
    value               = "Autoscaling-frontend-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "Production"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "backend" {
  name = "BackendASG"

  launch_template {
    id      = aws_launch_template.backend.id
    version = "$Latest"
  }

  min_size          = 1
  max_size          = 3
  desired_capacity  = 1
  vpc_zone_identifier = [aws_subnet.private1.id, aws_subnet.private2.id]

  target_group_arns = [aws_lb_target_group.backend.arn]

  health_check_type          = "ELB"
  health_check_grace_period  = 300

  tag {
    key                 = "Name"
    value               = "Autoscaling-backend-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "Production"
    propagate_at_launch = true
  }
}


resource "aws_lb_target_group_attachment" "frontend" {
  target_group_arn = aws_lb_target_group.frontend.arn
  target_id        = aws_instance.frontend.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "backend" {
  target_group_arn = aws_lb_target_group.backend.arn
  target_id        = aws_instance.backend.id
  port             = 8000
}

resource "aws_autoscaling_policy" "frontend" {
  name                   = "frontend-scaling-policy"
  policy_type            = "TargetTrackingScaling"
  
  target_tracking_configuration {
    target_value          = 50.0  # Your target CPU utilization percentage
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
  }
  
  autoscaling_group_name   = aws_autoscaling_group.frontend.name
}

resource "aws_autoscaling_policy" "backend" {
  name                   = "backend-scaling-policy"
  policy_type            = "TargetTrackingScaling"
  
  target_tracking_configuration {
    target_value          = 50.0  # Your target CPU utilization percentage
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
  }
  
  autoscaling_group_name   = aws_autoscaling_group.backend.name
}
