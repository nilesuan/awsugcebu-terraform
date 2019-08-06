resource "aws_s3_bucket" "deploymentsawsugcebuorg" { //  a bucket where k8 deployment files are stored
  bucket = "deployments.awsugcebu.org"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name        = "deployments-awsugcebu"
    Environment = "main"
    Stack       = "main"
  }
}