variable "common_tags" {
  type = map(string)
  default = {
    project   = "expense"
    env       = "dev"
    terraform = "true"
    component = "backend"
  }
}
variable "component" {
  default = "backend"
}
variable "env" {
  default = "dev"
}
variable "project" {
  default = "expense"
}
