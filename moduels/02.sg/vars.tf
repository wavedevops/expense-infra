variable "env" {}
variable "component" {}
variable "common_tags" {}
variable "vpc_tags" { default = {} }
variable "project"{}


variable "ingress_rules" { ## it means not create security inbound tropic then default
  type = list
  default = [
#     {
#       from_port = 0
#       to_port = 0
#       protocol = "-1"
#       cidr_blocks = ["0.0.0.0/0"]
#     }
  ]
}

variable "outbound_rules" {
  type = list
  default = [
    {
      from_port = 0
      to_port = 0
      protocol = "-1" # all protocols
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "sg_tags" { default = {} }
variable "vpc_id" {}