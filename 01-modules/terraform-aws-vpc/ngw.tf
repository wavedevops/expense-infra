# resource "aws_eip" "nat" {
#   domain   = "vpc"
# }
#
# resource "aws_nat_gateway" "nat" {
#   allocation_id = aws_eip.nat.id
#   subnet_id     = aws_subnet.public[0].id
#
#   tags = merge(
#     var.common_tags,
#     var.nat_gateway_tags,
#     {
#       Name = "${local.resource_name}" #expense-dev
#     }
#   )
#
#   # To ensure proper ordering, it is recommended to add an explicit dependency
#   # on the Internet Gateway for the VPC.
#   depends_on = [aws_internet_gateway.gw] # this is explicit dependency
# }
#
# resource "aws_route" "private_route_nat" {
#   route_table_id            = aws_route_table.private.id
#   destination_cidr_block    = "0.0.0.0/0"
#   nat_gateway_id = aws_nat_gateway.nat.id
# }
#
# resource "aws_route" "database_route_nat" {
#   route_table_id            = aws_route_table.database.id
#   destination_cidr_block    = "0.0.0.0/0"
#   nat_gateway_id = aws_nat_gateway.nat.id
# }