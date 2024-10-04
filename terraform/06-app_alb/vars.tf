variable "env" {
  default = "dev"
}
variable "project" {
  default = "expense"
}
variable "component" {
  default = "app-alb"
}

variable "common_tags" {
  type = map(string)
  default = {
    project   = "expense"
    env       = "dev"
    terraform = "true"
    component = "app-alb"
  }
}

