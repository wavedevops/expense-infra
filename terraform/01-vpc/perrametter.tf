resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.project}/${var.env}/vpc_id"
  type  = "String"
  value = module.vpc.vpc_id
}

resource "aws_ssm_parameter" "public_subnet_id" {
  name  = "/${var.project}/${var.env}/public_subnet_id"
  type  = "StringList"
  value = join(",",module.vpc.public_subnet_ids)
}

resource "aws_ssm_parameter" "private_subnet_id" {
  name  = "/${var.project}/${var.env}/private_subnet_id"
  type  = "StringList"
  value = join(",",module.vpc.private_subnet_ids)
}

resource "aws_ssm_parameter" "database_subnet_id" {
  name  = "/${var.project}/${var.env}/database_subnet_id"
  type  = "StringList"
  value = join(",",module.vpc.database_subnet_ids)
}

resource "aws_ssm_parameter" "db_subnet_id" {
  name  = "/${var.project}/${var.env}/db_subnet_id"
  type  = "StringList"
  value = module.vpc.db_subnet_id
}
# resource "aws_ssm_parameter" "public_subnet_id" {
#   name  = "/${var.project}/${var.env}/public_subnet_id"
#   type  = "String"
#   value = join(",",module.vpc.public_subnet)
# }
# output "public_subnet" {
#   value = aws_subnet.public.id
# }
#
# output "private_subnet" {
#   value = aws_subnet.private.id
# }
#
# output "database_subnet" {
#   value = aws_subnet.database.id
# }
