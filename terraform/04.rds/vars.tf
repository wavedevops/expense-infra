variable "env" {
  default = "dev"
}

variable "component" {
  default = "mysql"
}

variable "project" {
  default = "expense"
}


variable "common_tags" {
  default = {
    Project     = "expense"
    Environment = "dev"
    Terraform    = "true"
  }
}