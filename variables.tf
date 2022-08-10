variable "region" {}
variable "domain_name" {}
variable "bucket_name" {}
variable "customer_full_name" {}
variable "cidr_block" {}
variable "tier" {}
variable "vpc_id" {}

#Cloudfront
variable "cloudfront_price_class" {}

#subnets
variable "subnet_public_a" {}
variable "subnet_public_b" {}
variable "subnet_private_a" {}
variable "subnet_private_b" {}
variable "subnet_private_c" {}
variable "subnet_private_d" {}

#EC2
variable "edge_target_group_name" {}
variable "instance_size" {
  type = map(any)
}
variable "amis" {
  type = map(any)
}
#Autoscaling
variable "asg_size" {
  type = map(any)
}
variable "devops_admin" {}
variable "devops_admin_public_ip" {}

#ElastiCache
variable "instance_type" {}
variable "port" {}
variable "cluster_size" {}
variable "elasticache_parameter_group_family" {}
variable "max_item_size" {}

#Aurora
variable "engine" {}
variable "engine_version" {}
variable "user_name" {}
variable "allocated_storage" {}
variable "maintenance_window" {}
variable "backup_window" {}
variable "backup_retention_period" {}
variable "db_port" {}
variable "mutli_az" {}
