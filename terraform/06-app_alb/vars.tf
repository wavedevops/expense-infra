variable "common_tags" {
  type = map(string)
  default = {
    project   = "expense"
    env       = "dev"
    terraform = "true"
    component = "app-alb"
  }
}
variable "component" {
  default = "app_alb"
}
variable "env" {
  default = "dev"
}
variable "project" {
  default = "expense"
}
