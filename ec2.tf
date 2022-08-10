#Bastion 
resource "aws_instance" "bastion01" {
  ami                         = var.amis["bastion"]
  availability_zone           = "${var.region}a"
  instance_type               = var.instance_size["bastion"]
  monitoring                  = false
  subnet_id                   = aws_subnet.wordpress-public-1a.id
  vpc_security_group_ids      = [aws_security_group.DEVOPS_ADMIN.id]
  associate_public_ip_address = true
  source_dest_check           = true
  key_name                    = "ssh-keys.pub"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 16
    delete_on_termination = true
  }
  tags = {
    Client = "harrydowsettresume"
    Name   = "Bastion-Region-A"
  }
}

resource "aws_instance" "bastion02" {
  ami                         = var.amis["bastion"]
  availability_zone           = "${var.region}b"
  instance_type               = var.instance_size["bastion"]
  monitoring                  = false
  subnet_id                   = aws_subnet.wordpress-public-1b.id
  vpc_security_group_ids      = [aws_security_group.DEVOPS_ADMIN.id]
  associate_public_ip_address = true
  source_dest_check           = true
  key_name                    = "ssh-keys.pub"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 16
    delete_on_termination = true
  }
  tags = {
    Client = "harrydowsettresume"
    Name   = "Bastion-Region-B"
  }
}

##eip bastion01
resource "aws_eip" "bastion01" {
  vpc = true
  tags = {
    Name = "bastion01"
  }
}

resource "aws_eip_association" "bastion01_eip_assoc" {
  instance_id   = aws_instance.bastion01.id
  allocation_id = aws_eip.bastion01.id
}

output "bastion01_ip_addr" {
  value = aws_eip.bastion01.public_ip
}

##eip bastion02
resource "aws_eip" "bastion02" {
  vpc = true
  tags = {
    Name = "bastion02"
  }
}

resource "aws_eip_association" "bastion02_eip_assoc" {
  instance_id   = aws_instance.bastion02.id
  allocation_id = aws_eip.bastion02.id
}

output "bastion02_ip_addr" {
  value = aws_eip.bastion02.public_ip
}

#EC2 Private
resource "aws_instance" "ec201" {
  ami                         = var.amis["bastion"]
  availability_zone           = "${var.region}a"
  instance_type               = var.instance_size["bastion"]
  monitoring                  = false
  subnet_id                   = aws_subnet.wordpress-private-1a.id
  vpc_security_group_ids      = [aws_security_group.DEVOPS_ADMIN.id]
  associate_public_ip_address = true
  source_dest_check           = true
  #key_name                    = "DEVOPS_ADMIN_key"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 16
    delete_on_termination = true
  }
  tags = {
    Client = "harrydowsettresume"
    Name   = "Private-Region-A"
  }
}

resource "aws_instance" "ec202" {
  ami                         = var.amis["bastion"]
  availability_zone           = "${var.region}b"
  instance_type               = var.instance_size["bastion"]
  monitoring                  = false
  subnet_id                   = aws_subnet.wordpress-private-1b.id
  vpc_security_group_ids      = [aws_security_group.DEVOPS_ADMIN.id]
  associate_public_ip_address = true
  source_dest_check           = true
  #key_name                    = "DEVOPS_ADMIN_key"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 16
    delete_on_termination = true
  }
  tags = {
    Client = "harrydowsettresume"
    Name   = "Private-Region-B"
  }
}
