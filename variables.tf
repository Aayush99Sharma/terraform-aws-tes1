
variable "AWS_ACCESS_KEY_ID" {
  type        = string
  description = "AWS Access Key ID"
}

variable "AWS_SECRET_ACCESS_KEY" {
  type        = string
  description = "AWS Secret Access Key"
  sensitive   = true
}

variable "public_subnet2_cidr" {
  description = "CIDR block for the second public subnet"
}

variable "db_instance_class" {
  description = "Instance class for the database"
}

variable "master_user_password" {
  description = "Database master user password"
  sensitive   = true
}

variable "multi_az" {
  description = "Enable Multi-AZ for the database instance"
}

variable "region" {
  description = "AWS region for resource deployment"
}

variable "az1" {
  description = "First availability zone"
}

variable "az2" {
  description = "Second availability zone"
}

variable "private_subnet1_cidr" {
  description = "CIDR block for the first private subnet"
}

variable "private_subnet2_cidr" {
  description = "CIDR block for the second private subnet"
}

variable "public_subnet1_cidr" {
  description = "CIDR block for the first public subnet"
}

variable "engine_version" {
  description = "Database engine version"
}

variable "db_instance_identifier" {
  description = "Identifier for the database instance"
}

variable "Frontend_ami_id" {
  description = "AMI ID for the frontend instance"
}

variable "Backend_ami_id" {
  description = "AMI ID for the backend instance"
}

variable "instance_type" {
  description = "Instance type for EC2 instances"
}

variable "key_name" {
  description = "Key pair name for EC2 instances"
}

variable "db_name" {
  description = "Name of the database"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
}

variable "db_allocated_storage" {
  description = "Storage size (in GB) for the database"
}

variable "master_username" {
  description = "Database master username"
}

variable "availability_zone" {
  description = "Availability zone for resources"
}
