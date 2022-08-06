resource "aws_security_group" "DEVOPS_ADMIN" {
  name        = "DEVOPS_ADMIN"
  description = "Security group for DEVOPS_ADMIN access"
  vpc_id      = aws_vpc.harrydowsettresume_wordpress.id

  #inbound admin whitelist
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    #inbound ssh from: devops admins
    cidr_blocks = [var.devops_admin_public_ip]
    self        = true
  }
  #icmp from the office and vpn for ping
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.devops_admin_public_ip]
    self        = true
  }
  #EFS ingress
  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"
  }
  #wide open egress
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DEVOPS_ADMIN access"
  }
}


resource "aws_security_group" "edge-frontends-instances" {
  name        = "edge-frontends-instances"
  description = "Security group for edge-frontends instances"
  vpc_id      = aws_vpc.harrydowsettresume_wordpress.id

  #inbound 80 from the alb and DEVOPS_ADMIN
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.edge-frontends-alb.id, aws_security_group.DEVOPS_ADMIN.id]
  }
  #inbound 443 from the alb and DEVOPS_ADMIN
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.edge-frontends-alb.id, aws_security_group.DEVOPS_ADMIN.id]
  }
  #inbound 22 from DEVOPS_ADMIN
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.DEVOPS_ADMIN.id]
    self            = true
  }
  #wide open egress
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Edge Frontends instances"
  }
}


resource "aws_security_group" "edge-frontends-alb" {
  name        = "edge-frontends-alb"
  description = "Security group for edge-frontends ALB"
  vpc_id      = aws_vpc.harrydowsettresume_wordpress.id

  #inbound 80 from the alb
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["67.164.84.151/32"]
  }
  #inbound 443 from the alb
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = ["67.164.84.151/32"]
    security_groups = [aws_security_group.DEVOPS_ADMIN.id]
  }
  #wide open egress
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #inbound 80 from the DEVOPS_ADMIN
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.DEVOPS_ADMIN.id]
  }

  tags = {
    Name = "${var.customer_full_name} ALB"
  }
}

#Elasticache SG
resource "aws_security_group" "elasticache" {
  name        = "elasticache"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.harrydowsettresume_wordpress.id

  ingress {
    description = "TLS from VPC"
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

#Aurora DB

resource "aws_security_group" "aurora_db" {
  name        = "aurora_db"
  description = "database"
  vpc_id      = aws_vpc.harrydowsettresume_wordpress.id

  ingress {
    description = "TLS from VPC"
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}


