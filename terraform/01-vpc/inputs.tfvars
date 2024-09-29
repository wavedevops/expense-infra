env         = "dev"
project     = "expense"

common_tags = {
  Project     = "expense"
  Environment = "dev"
  Terrafom    = "teue"
}

vpc_cidr          = "10.0.0.0/16"
azs               = ["us-east-1a", "us-east-1b"]
private_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnets    = ["10.0.11.0/24", "10.0.12.0/24"]
database_subnets  = ["10.0.21.0/24", "10.0.22.0/24"]
default_vpc_id    = "vpc-0f54167fa22079c54"
default_vpc_cidr  = "172.31.0.0/16"