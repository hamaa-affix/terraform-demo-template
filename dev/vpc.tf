/*
   vpc
*/
resource "aws_vpc" "app_env" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = var.env
  }
}

/*
  internet gateway
*/
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.app_env.id

  tags = {
    Name = var.env
  }
}

/*
  nat gateway
*/
resource "aws_eip" "eip_for_nat_gateway" {
  vpc        = true
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.eip_for_nat_gateway.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "gw NAT"
  }
}


/*
  public sub net
*/
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.app_env.id
  count             = 3
  availability_zone = var.azs[count.index]
  cidr_block = cidrsubnet(aws_vpc.app_env.cidr_block, 8, count.index)

  tags = {
    Name = "public_web_${var.env}"
  }
}

/*
  private sub net
*/
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.app_env.id
  count             = 3
  availability_zone = var.azs[count.index]
  cidr_block = cidrsubnet(aws_vpc.app_env.cidr_block, 8, count.index + length(aws_subnet.public))


  tags = {
    Name = "private_web_${var.env}"
  }
}

/*
  database sub net
*/
resource "aws_subnet" "db" {
  vpc_id            = aws_vpc.app_env.id
  count             = 3
  availability_zone = var.azs[count.index]
  cidr_block = cidrsubnet(aws_vpc.app_env.cidr_block, 8, count.index + (length(aws_subnet.public) * 2))


  tags = {
    Name = "db_${var.env}"
  }
}

/*
  web route table //public
*/
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.app_env.id

  tags = {
    Name = "public_route_table"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.gw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public_route_table_assciation" {
  count          = 3
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

/*
  nat route table //private
*/

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.app_env.id

  tags = {
    Name = "private_for_nat"
  }
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private.id
  gateway_id             = aws_nat_gateway.nat_gw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "private_route_table_assciation" {
  count          = 3
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}


/*
  private route table //db = local
*/
resource "aws_route_table" "db" {
  vpc_id = aws_vpc.app_env.id

  tags = {
    Name = "db_in_local"
  }
}
resource "aws_route_table_association" "db_route_table_assciation" {
  count          = 3
  subnet_id      = aws_subnet.db[count.index].id
  route_table_id = aws_route_table.db.id
}
