#VPC	
resource "aws_vpc" "harrydowsettresume_wordpress" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "Wordpress Arch"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "harrydowsettresume" {
  vpc_id = aws_vpc.harrydowsettresume_wordpress.id

  tags = {
    Name = "Wordpress Arch"
  }
  lifecycle {
    create_before_destroy = true
  }
}

#Nat Gateway
resource "aws_eip" "nat-1a" {
  vpc = true
  tags = {
    Name = var.customer_full_name
  }
}

resource "aws_nat_gateway" "wordpress-public-1a" {
  #this is the elastic ip association
  allocation_id = aws_eip.nat-1a.id
  subnet_id     = aws_subnet.wordpress-public-1a.id
  depends_on    = [aws_internet_gateway.harrydowsettresume]
  tags = {
    Name = var.customer_full_name
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eip" "nat-1b" {
  vpc = true
  tags = {
    Name = var.customer_full_name
  }
}

resource "aws_nat_gateway" "wordpress-public-1b" {
  #this is the elastic ip association
  allocation_id = aws_eip.nat-1b.id
  subnet_id     = aws_subnet.wordpress-public-1b.id
  depends_on    = [aws_internet_gateway.harrydowsettresume]
  tags = {
    Name = var.customer_full_name
  }
  lifecycle {
    create_before_destroy = true
  }
}


#Subnets
resource "aws_subnet" "wordpress-public-1a" {
  vpc_id                  = aws_vpc.harrydowsettresume_wordpress.id
  cidr_block              = var.subnet_public_a
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "harrydowsettresume Public 1a"
  }
}

resource "aws_subnet" "wordpress-public-1b" {
  vpc_id                  = aws_vpc.harrydowsettresume_wordpress.id
  cidr_block              = var.subnet_public_b
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = true

  tags = {
    Name = "harrydowsettresume Public 1b"
  }
}

resource "aws_subnet" "wordpress-private-1a" {
  vpc_id                  = aws_vpc.harrydowsettresume_wordpress.id
  cidr_block              = var.subnet_private_a
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = false

  tags = {
    Name = "harrydowsettresume Private 1a App"
  }
}

resource "aws_subnet" "wordpress-private-1b" {
  vpc_id                  = aws_vpc.harrydowsettresume_wordpress.id
  cidr_block              = var.subnet_private_b
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = false

  tags = {
    Name = "harrydowsettresume Private 1b App"
  }
}

resource "aws_subnet" "wordpress-private-1c" {
  vpc_id                  = aws_vpc.harrydowsettresume_wordpress.id
  cidr_block              = var.subnet_private_c
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = false

  tags = {
    Name = "harrydowsettresume Private 1c Data"
  }
}

resource "aws_subnet" "wordpress-private-1d" {
  vpc_id                  = aws_vpc.harrydowsettresume_wordpress.id
  cidr_block              = var.subnet_private_d
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = false

  tags = {
    Name = "harrydowsettresume Private 1d Data"
  }
}


#Route Tables
resource "aws_route_table" "wordpress-public-1a" {
  vpc_id = aws_vpc.harrydowsettresume_wordpress.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.harrydowsettresume.id
  }

  tags = {
    Name = "harrydowsettresume public 1a"
  }
}

resource "aws_route_table" "wordpress-public-1b" {
  vpc_id = aws_vpc.harrydowsettresume_wordpress.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.harrydowsettresume.id
  }

  tags = {
    Name = "harrydowsettresume public 1b"
  }
}

resource "aws_route_table" "wordpress-private-1a" {
  vpc_id = aws_vpc.harrydowsettresume_wordpress.id

  tags = {
    Name = "harrydowsettresume private 1a"
  }
}

resource "aws_route_table" "wordpress-private-1b" {
  vpc_id = aws_vpc.harrydowsettresume_wordpress.id

  tags = {
    Name = "harrydowsettresume private 1b"
  }
}

resource "aws_route_table" "wordpress-private-1c" {
  vpc_id = aws_vpc.harrydowsettresume_wordpress.id

  tags = {
    Name = "harrydowsettresume private 1c"
  }
}

resource "aws_route_table" "wordpress-private-1d" {
  vpc_id = aws_vpc.harrydowsettresume_wordpress.id

  tags = {
    Name = "harrydowsettresume private 1d"
  }
}

#Route Table Association
resource "aws_route_table_association" "wordpress-public-1a-rta" {
  route_table_id = aws_route_table.wordpress-public-1a.id
  subnet_id      = aws_subnet.wordpress-public-1a.id
}

resource "aws_route_table_association" "wordpress-public-1b-rta" {
  route_table_id = aws_route_table.wordpress-public-1b.id
  subnet_id      = aws_subnet.wordpress-public-1b.id
}

resource "aws_route_table_association" "wordpress-private-1a-rta" {
  route_table_id = aws_route_table.wordpress-private-1a.id
  subnet_id      = aws_subnet.wordpress-private-1a.id
}

resource "aws_route_table_association" "wordpress-private-1b-rta" {
  route_table_id = aws_route_table.wordpress-private-1b.id
  subnet_id      = aws_subnet.wordpress-private-1b.id
}

resource "aws_route_table_association" "wordpress-private-1c-rta" {
  route_table_id = aws_route_table.wordpress-private-1c.id
  subnet_id      = aws_subnet.wordpress-private-1c.id
}

resource "aws_route_table_association" "wordpress-private-1d-rta" {
  route_table_id = aws_route_table.wordpress-private-1d.id
  subnet_id      = aws_subnet.wordpress-private-1d.id
}
