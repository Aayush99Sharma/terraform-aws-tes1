#module "ec2" {
#  source        = "./modules/ec2"
#  ami           = var.ami
#  instance_type = var.instance_type
#  subnet_id     = var.subnet_id
#}





module "demo1" {
  source  = "app.terraform.io/aayush8276/demo1/aws"
  version = "1.0.0"
  public_subnet2_cidr   = var.public_subnet2_cidr
  db_instance_class     = var.db_instance_class
  master_user_password  = var.master_user_password
  multi_az              = var.multi_az
  region                = var.region
  az1                   = var.az1
  az2                   = var.az2
  private_subnet1_cidr  = var.private_subnet1_cidr
  private_subnet2_cidr  = var.private_subnet2_cidr
  public_subnet1_cidr   = var.public_subnet1_cidr
  engine_version        = var.engine_version
  db_instance_identifier = var.db_instance_identifier
  Frontend_ami_id       = var.Frontend_ami_id
  Backend_ami_id        = var.Backend_ami_id
  instance_type         = var.instance_type
  key_name              = var.key_name
  db_name               = var.db_name
  vpc_cidr              = var.vpc_cidr
  db_allocated_storage  = var.db_allocated_storage
  master_username       = var.master_username 
  availability_zone     = var.availability_zone
}


