module "vpc" {
  source           = "../../moduels/01.vpc"
  env              = var.env
  vpc_cidr         = var.vpc_cidr
  common_tags      = var.common_tags
  azs              = var.azs
  private_subnets  = var.private_subnets
  public_subnets   = var.public_subnets
  database_subnets = var.database_subnets
  default_vpc_id   = var.default_vpc_id
  default_vpc_cidr = var.default_vpc_cidr
  project          = var.project
}


# module "vpc" {
# #   source =   "git::https://github.com/Chowdary-Hari/terraform.git"
#   source = "git::https://github.com/wavedevops/practice.git//terraform/vpc"
#   component = var.component
#   env = var.env
#   vpc_cidr = var.vpc_cidr
#   common_tags = var.common_tags
#   azs = var.azs
#   private_subnets = var.private_subnets
#   public_subnets = var.public_subnets
#   database_subnets = var.database_subnets
#   default_vpc_id = var.default_vpc_id
#   default_vpc_cidr = var.default_vpc_cidr
# }