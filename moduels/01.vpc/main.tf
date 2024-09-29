resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = merge(
    var.common_tags,
    var.vpc_tags,
    {
      Name = "${var.project}-${var.env}"
    }
  )
}

resource "aws_subnet" "public" {
  count = length(var.public_subnets)
  map_public_ip_on_launch = true
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(
    var.common_tags,
    var.vpc_tags,
    {
      Name = "${var.project}-${var.env}-public-${count.index + 1}"
    }
  )
}

resource "aws_subnet" "private" {
  count = length(var.private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(
    var.common_tags,
    var.vpc_tags,
    {
      Name = "${var.project}-${var.env}-private-${count.index + 1}"
    }
  )
}

resource "aws_subnet" "database" {
  count = length(var.database_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.database_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(
    var.common_tags,
    var.vpc_tags,
    {
      Name = "${var.project}-${var.env}-database-${count.index + 1}"
    }
  )
}

##### database subnet group
resource "aws_db_subnet_group" "db" {
  name       = "${var.project}-${var.env}"
  subnet_ids = aws_subnet.database[*].id

  tags = merge(
    var.common_tags,
    var.vpc_tags,
    {
      Name = "${var.project}-${var.env}"
    }
  )
}




resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.vpc_tags,
    {
      Name = "${var.project}-${var.env}-igw"
    }
  )
}

# resource "aws_eip" "eip" {
#   domain   = "vpc"
#   tags = merge(
#     var.common_tags,
#     var.vpc_tags,
#     {
#       Name = "${var.project}-${var.env}-eip"
#     }
#   )
# }
#
# resource "aws_nat_gateway" "nat" {
#   allocation_id = aws_eip.eip.id
#   subnet_id     = aws_subnet.public[0].id
#   tags = merge(
#     var.common_tags,
#     var.vpc_tags,
#     {
#       Name = "${var.project}-${var.env}-nat"
#     }
#   )
# }

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.vpc_tags,
    {
      Name = "${var.project}-${var.env}-public"
    }
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.vpc_tags,
    {
      Name = "${var.project}-${var.env}-private"
    }
  )
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.vpc_tags,
    {
      Name = "${var.project}-${var.env}-database"
    }
  )
}

resource "aws_route" "public_route" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

# resource "aws_route" "private_route" {
#   route_table_id            = aws_route_table.private.id
#   destination_cidr_block    = "0.0.0.0/0"
#   nat_gateway_id = aws_nat_gateway.nat.id
# }
#
# resource "aws_route" "database_route" {
#   route_table_id            = aws_route_table.database.id
#   destination_cidr_block    = "0.0.0.0/0"
#   nat_gateway_id = aws_nat_gateway.nat.id
# }

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)
#   subnet_id      = element(aws_subnet.public[*].id, count.index)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" {
  count = length(var.database_subnets)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}