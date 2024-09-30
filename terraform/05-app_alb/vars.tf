variable "common_tags" {
  type = map(string)
  default = {
    Project   = "expense"
    env       = "dev"
    Terraform = "true"
    Component = "app_alb"
  }
}

