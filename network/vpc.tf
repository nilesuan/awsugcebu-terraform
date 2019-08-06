resource "aws_default_vpc" "vpc" { // aws usergroup cebu vpc
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "vpc"
    Environment = "main"
    Stack       = "main"
    Stack       = "main"
  }
}

resource "aws_internet_gateway" "igw" { // main internet gateway used by the aws usergroup cebu vpc
  vpc_id = "${aws_default_vpc.vpc.id}"

  tags = {
    Name        = "igw"
    Environment = "main"
    Stack       = "main"
  }
}