provider "aws" {
  region = var.region
}

# Variables (removed defaults, to be loaded from secrets.tfvars)

variable "region" {
  description = "AWS Region where resources will be created."
  type        = string
}

variable "az1" {
  description = "First Availability Zone in the region."
  type        = string
}

variable "az2" {
  description = "Second Availability Zone in the region."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "public_subnet1_cidr" {
  description = "CIDR block for Public Subnet 1."
  type        = string
}

variable "public_subnet2_cidr" {
  description = "CIDR block for Public Subnet 2."
  type        = string
}

variable "private_subnet1_cidr" {
  description = "CIDR block for Private Subnet 1."
  type        = string
}

variable "private_subnet2_cidr" {
  description = "CIDR block for Private Subnet 2."
  type        = string
}

variable "Backend_ami_id" {
  description = "AMI ID for backend EC2 instance"
  type        = string
}

variable "Frontend_ami_id" {
  description = "AMI ID for frontend EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Type of the EC2 instance"
  type        = string
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
}

# RDS-related variables
variable "db_name" {
  description = "The name of the database to create."
  type        = string
}

variable "db_allocated_storage" {
  description = "The size of the database (in GB)."
  type        = number
}

variable "db_instance_class" {
  description = "The compute and memory capacity of the DB instance."
  type        = string
}

variable "engine_version" {
  description = "The version of the database engine to use."
  type        = string
}

variable "master_username" {
  description = "Master username for the RDS instance."
  type        = string
}

variable "master_user_password" {
  description = "Master password for the RDS instance."
  type        = string
  sensitive   = true
}

variable "multi_az" {
  description = "Whether to create a Multi-AZ DB instance."
  type        = bool
}

variable "availability_zone" {
  description = "The Availability Zone for the RDS instance."
  type        = string
}

variable "db_instance_identifier" {
  description = "Unique identifier for the DB instance."
  type        = string
}
