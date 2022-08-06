region                 = "us-east-1"
domain_name            = "harrydowsettresume.co.uk"
bucket_name            = "harrydowsettresume"
customer_full_name     = "harry_dowsett"
cloudfront_price_class = "PriceClass_100"
cidr_block             = "10.11.0.0/16"
subnet_public_a        = "10.11.3.0/24"
subnet_public_b        = "10.11.4.0/24"
subnet_private_a       = "10.11.1.0/24"
subnet_private_b       = "10.11.2.0/24"
subnet_private_c       = "10.11.5.0/24"
subnet_private_d       = "10.11.6.0/24"
devops_admin           = "DEVOPS_ADMIN"
devops_admin_public_ip = "94.10.139.22/32"
tier                   = "stage"
edge_target_group_name = "Edge-Frontends"
vpc_id                 = "aws_vpc.harrydowsettresume_wordpress.id"

amis = {
  "bastion" = "ami-0cff7528ff583bf9a"
  "asg"     = "ami-0cff7528ff583bf9a"
}


instance_size = {
  "bastion" = "t2.micro"
  "asg"     = "t2.micro"
  "db"      = "db.t2.micro"
}

asg_size = {
  "max"     = "2"
  "min"     = "2"
  "desired" = "2"
}

instance_type                      = "cache.t2.micro"
port                               = "11211"
cluster_size                       = "1"
elasticache_parameter_group_family = "memcached1.5"
max_item_size                      = "10485760"

engine                  = "mysql"
engine_version          = "5.7"
user_name               = "admin"
allocated_storage       = "10"
maintenance_window      = "Mon:00:00-Mon:03:00"
backup_window           = "10:46-11:16"
backup_retention_period = "1"
db_port                 = "3306"
mutli_az                = "true"
