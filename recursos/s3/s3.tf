resource "aws_s3_bucket" "default" {
  bucket = "${var.bucketname}${var.refpath}"
  acl    = "private"
    policy = <<-EOT
    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${var.bucketname}${var.refpath}/*",
            "Condition": {
                "IpAddress": {
                    "aws:SourceIp": [
                        "0.0.0.0/0"
                    ]
                }
            }
        }
      ]
    }
    EOT

  website {
    index_document = "index.html"
    error_document = "error.html"
  
  }

  tags = {
    ProjectName = "${var.projectname}"
  }
}