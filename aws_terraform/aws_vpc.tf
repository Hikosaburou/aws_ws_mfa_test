resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name  = "${var.prefix}-${var.account}-vpc"
    owner = var.prefix
  }
}

resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name  = "${var.prefix}-${var.account}-igw"
    owner = var.prefix
  }
}

resource "aws_eip" "nat_gw" {
  tags = {
    Name  = "${var.prefix}-${var.account}-eip-nat-gw"
    owner = var.prefix
  }
}

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_public_a
  availability_zone = "ap-northeast-1a"

  tags = {
    Name  = "${var.prefix}-${var.account}-public_a"
    owner = var.prefix
  }
}

resource "aws_subnet" "public_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_public_c
  availability_zone = "ap-northeast-1c"

  tags = {
    Name  = "${var.prefix}-${var.account}-public_c"
    owner = var.prefix
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public.id
  }

  tags = {
    Name  = "${var.prefix}-${var.account}-routetable-public"
    owner = var.prefix
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.public.id
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_gw.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name  = "${var.prefix}-${var.account}-nat_gw"
    owner = var.prefix
  }
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_private_a
  availability_zone = "ap-northeast-1a"

  tags = {
    Name  = "${var.prefix}-${var.account}-private_a"
    owner = var.prefix
  }
}

resource "aws_subnet" "private_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_private_c
  availability_zone = "ap-northeast-1c"

  tags = {
    Name  = "${var.prefix}-${var.account}-private_c"
    owner = var.prefix
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name  = "${var.prefix}-${var.account}-routetable-private"
    owner = var.prefix
  }
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_c" {
  subnet_id      = aws_subnet.private_c.id
  route_table_id = aws_route_table.private.id
}
