module "vpcmodule" {
  source               = "../../modules/vpc"
  vpc_cidr_block       = var.vpc_cidr_block
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  environment          = var.environment
  vpc_name             = var.vpc_name
  subnet_name          = var.subnet_name
}


module "albmodule" {
  source            = "../../modules/alb"
  vpc_id            = module.vpcmodule.vpc_id
  public_subnet_ids = module.vpcmodule.public_subnet_ids
  environment       = var.environment
}


module "webservers" {
  source           = "../../modules/webservers"
  vpc_id           = module.vpcmodule.vpc_id
  sg_ingress_ports = var.sg_ingress_ports
  key_name         = var.key_name
  instance_type    = var.instance_type
  environment      = var.environment
  user_data        = var.user_data
}


module "asgmodule" {
  source           = "../../modules/asg"
  vpc_zone_ids     = module.vpcmodule.private_subnet_ids
  lt_id            = module.webservers.lt_id           # <- You need to output this in ec2module
  target_group_arn = module.albmodule.target_group_arn # <- Output this in albmodule
  environment      = var.environment
}
