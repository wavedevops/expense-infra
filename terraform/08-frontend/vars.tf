variable "common_tags" {
  type = map(string)
  default = {
    project   = "expense"
    env       = "dev"
    terraform = "true"
    component = "frontend"
  }
}
variable "component" {
  default = "frontend"
}
variable "env" {
  default = "dev"
}
variable "project" {
  default = "expense"
}

variable "web_alb_tags" {
  default = {
    Component = "web-alb"
  }
}