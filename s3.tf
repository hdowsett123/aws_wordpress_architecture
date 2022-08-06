data "aws_elb_service_account" "main" {}

resource "aws_s3_bucket" "harrydowsettresume" {
  bucket = var.bucket_name

  tags = {
    Name        = "wordpress-images"
    Environment = "Prod"
  }
}

resource "aws_s3_bucket_acl" "wordpress" {
  bucket = aws_s3_bucket.harrydowsettresume.id
  acl    = "private"
}

locals {
  s3_origin_id = "myS3Origin"
}

resource "aws_s3_bucket" "wordpress_elb_logs" {
  bucket        = "harrydowsettresume-logs-${var.tier}"
  acl           = "private"
  force_destroy = true
  tags = {
    Name = "LB Logs"
  }

  policy = <<EOF
 {
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : ["${data.aws_elb_service_account.main.arn}"]
        },
        "Action" : ["s3:PutObject"],
        "Resource" : ["arn:aws:s3:::harrydowsettresume-logs-${var.tier}/*"]
      }
    ] 
 }
   EOF
}
