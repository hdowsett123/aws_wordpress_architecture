resource "aws_placement_group" "harrydowsettresume" {
  name     = "Edge frontends"
  strategy = "cluster"
}

resource "aws_launch_configuration" "edge-frontends" {
  name_prefix     = "edge-frontends autoscaling launch configuration"
  image_id        = var.amis["asg"]
  instance_type   = var.instance_size["asg"]
  security_groups = [aws_security_group.edge-frontends-instances.id]
  user_data       = "wordpress-web"
  lifecycle {
    create_before_destroy = true
  }
}

#Bastion
resource "aws_autoscaling_group" "edge-frontends" {
  vpc_zone_identifier       = [aws_subnet.wordpress-public-1a.id, aws_subnet.wordpress-public-1b.id]
  name                      = "edge-frontends"
  max_size                  = var.asg_size["max"]
  min_size                  = var.asg_size["min"]
  wait_for_capacity_timeout = "300s"
  health_check_grace_period = 10
  health_check_type         = "EC2"
  desired_capacity          = var.asg_size["desired"]
  target_group_arns         = [aws_alb_target_group.alb_target.arn]
  force_delete              = true
  launch_configuration      = aws_launch_configuration.edge-frontends.name
  depends_on                = [aws_lb.frontends]

  #tags = {
  #  key                 = "Name"
  #  value               = "${aws_alb_target_group.alb_target.name} autoscaled instance"
  #  propagate_at_launch = true
  #}

  timeouts {
    delete = "15m"
  }

}

#Private EC2
resource "aws_autoscaling_group" "private-edge-frontends" {
  vpc_zone_identifier       = [aws_subnet.wordpress-private-1a.id, aws_subnet.wordpress-private-1b.id]
  name                      = "private-edge-frontends"
  max_size                  = var.asg_size["max"]
  min_size                  = var.asg_size["min"]
  wait_for_capacity_timeout = "300s"
  health_check_grace_period = 10
  health_check_type         = "EC2"
  desired_capacity          = var.asg_size["desired"]
  target_group_arns         = [aws_alb_target_group.alb_target.arn]
  force_delete              = true
  launch_configuration      = aws_launch_configuration.edge-frontends.name
  depends_on                = [aws_lb.frontends]

  #tags = {
  #  key                 = "Name"
  #  value               = "${aws_alb_target_group.alb_target.name} autoscaled instance"
  #  propagate_at_launch = true
  #}

  timeouts {
    delete = "15m"
  }

}

