##### this is optional  main.tf already will create but

resource "aws_eip" "eip" {
  domain   = "vpc"
  tags = merge(
    var.common_tags,
    var.vpc_tags,
    {
      Name = "${var.project}-${var.env}-eip"
    }
  )
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public[0].id
  tags = merge(
    var.common_tags,
    var.vpc_tags,
    {
      Name = "${var.project}-${var.env}-nat"
    }
  )
}


resource "aws_route" "private_route" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}

resource "aws_route" "database_route" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}

