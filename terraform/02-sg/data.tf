data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project}/${var.env}/vpc_id"
}

data "aws_security_group" "allow_all" {
  filter {
    name   = "group-name"
    values = ["allow_all"]
  }
}