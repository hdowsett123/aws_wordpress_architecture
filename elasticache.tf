#Subnet Private 1c
resource "aws_elasticache_parameter_group" "wordpress-cluster" {
  name   = "wordpress-cluster"
  family = "memcached1.6"

  parameter {
    name  = "max_item_size"
    value = var.max_item_size
  }
}

resource "aws_elasticache_subnet_group" "private-1c-data" {
  name       = "Private-1c-data"
  subnet_ids = [aws_subnet.wordpress-private-1c.id]
}


resource "aws_elasticache_cluster" "wordpress-cluster-1c" {
  cluster_id           = "wordpress-cluster"
  engine               = "memcached"
  node_type            = var.instance_type
  num_cache_nodes      = var.cluster_size
  parameter_group_name = "wordpress-cluster"
  port                 = var.port
  subnet_group_name    = "private-1c-data"
  security_group_ids   = [aws_security_group.elasticache.id]
}

#Subnet Private 1d
resource "aws_elasticache_subnet_group" "private-1d-data" {
  name       = "Private-1d-data"
  subnet_ids = [aws_subnet.wordpress-private-1d.id]
}


resource "aws_elasticache_cluster" "wordpress-cluster-1d" {
  cluster_id           = "wordpress-cluster-1d"
  engine               = "memcached"
  node_type            = var.instance_type
  num_cache_nodes      = var.cluster_size
  parameter_group_name = "wordpress-cluster"
  port                 = var.port
  subnet_group_name    = "private-1d-data"
  security_group_ids   = [aws_security_group.elasticache.id]
}
