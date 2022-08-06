resource "aws_efs_file_system" "wordpress-efs" {
  creation_token   = "efs-token"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = "true"
  tags = {
    Name = "wordpress-efs"
  }
}

#EFS Target Mount 1b
resource "aws_efs_mount_target" "efs-mount-1b" {
  file_system_id  = aws_efs_file_system.wordpress-efs.id
  subnet_id       = aws_subnet.wordpress-private-1d.id
  security_groups = [aws_security_group.DEVOPS_ADMIN.id]
}

#EFS Mount Point 1b
resource "null_resource" "configure_nfs" {
  depends_on = [aws_efs_mount_target.efs-mount-1b]
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.my_key.private_key_pem
    host        = aws_instance.ec202.public_ip
  }
}

#EFS Target Mount 1a
resource "aws_efs_mount_target" "efs-mount-1a" {
  file_system_id  = aws_efs_file_system.wordpress-efs.id
  subnet_id       = aws_subnet.wordpress-private-1c.id
  security_groups = [aws_security_group.DEVOPS_ADMIN.id]
}

#EFS Mount Point 1a
resource "null_resource" "configure_nfs_1a" {
  depends_on = [aws_efs_mount_target.efs-mount-1a]
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.my_key.private_key_pem
    host        = aws_instance.ec201.public_ip
  }
}
