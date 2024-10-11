variable "common_tags" {
  type = map(string)
  default = {
    project   = "expense"
    env       = "dev"
    terraform = "true"
    component = "web-alb"
  }
}
variable "component" {
  default = "web-alb"
}
variable "env" {
  default = "dev"
}
variable "project" {
  default = "expense"
}
