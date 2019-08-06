resource "aws_s3_bucket" "dbbackupsawsugcebuorg" { // a bucket used for backing up the database
  bucket = "dbbackups.awsugcebu.org"
  acl    = "private"

  lifecycle_rule {
    id      = "transition"
    enabled = true

    tags = {
      "rule"      = "transition"
      "autoclean" = "true"
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }

    transition {
      days          = 150
      storage_class = "DEEP_ARCHIVE"
    }

    expiration {
      days = 365
    }
  }

  tags = {
    Name        = "backups-awsugcebu"
    Environment = "main"
    Stack       = "main"
  }
}