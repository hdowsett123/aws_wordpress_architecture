resource "aws_db_subnet_group" "DB_SUBNET_DATA_1D" {
  name       = "main"
  subnet_ids = [aws_subnet.wordpress-private-1d.id, aws_subnet.wordpress-private-1c.id]

  tags = {
    Name = "My DB subnet group Private 1d"
  }
}

resource "aws_db_instance" "master_aurora_db" {
  allocated_storage       = var.allocated_storage
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = "db.${var.instance_size["bastion"]}"
  name                    = "aurora_db"
  username                = var.user_name
  password                = random_string.password.result
  maintenance_window      = var.maintenance_window
  backup_window           = var.backup_window
  backup_retention_period = var.backup_retention_period
  port                    = var.db_port
  multi_az                = var.mutli_az

  final_snapshot_identifier = "prod-wordpress-db-snapshot"
  snapshot_identifier       = null
  skip_final_snapshot       = true
  vpc_security_group_ids    = [aws_security_group.aurora_db.id]
  db_subnet_group_name      = aws_db_subnet_group.DB_SUBNET_DATA_1D.id
}

resource "aws_db_instance" "replica_aurora_db" {
  allocated_storage       = var.allocated_storage
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = "db.${var.instance_size["bastion"]}"
  name                    = "aurora_db_replica"
  username                = var.user_name
  password                = random_string.password.result
  maintenance_window      = var.maintenance_window
  backup_window           = var.backup_window
  backup_retention_period = var.backup_retention_period
  port                    = var.db_port
  availability_zone       = "us-east-1a"

  final_snapshot_identifier = "prod-wordpress-db-replica-snapshot"
  snapshot_identifier       = null
  skip_final_snapshot       = true
  vpc_security_group_ids    = [aws_security_group.aurora_db.id]
  replicate_source_db       = aws_db_instance.master_aurora_db.id
}

resource "random_string" "password" {
  length  = 16
  special = false
}
