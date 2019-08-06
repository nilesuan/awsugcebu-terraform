resource "aws_s3_bucket" "tmpawsugcebuorg" { // a bucket used for temporary storage like lambda cloud formation packaging
  bucket = "tmp.awsugcebu.org"
  acl    = "private"

  lifecycle_rule {
    id      = "expire"
    enabled = true

    tags = {
      "rule"      = "expire"
      "autoclean" = "true"
    }

    expiration {
      days = 1
    }

    noncurrent_version_expiration {
      days = 1
    }
  }

  tags = {
    Name        = "tmp-awsugcebu"
    Environment = "temp"
    Stack       = "temp"
  }
}