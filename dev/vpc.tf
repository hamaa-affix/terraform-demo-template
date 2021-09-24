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
  route table
*/
