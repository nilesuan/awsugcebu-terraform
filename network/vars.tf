variable "region" {
  type    = "string"
  default = "ap-southeast-1"
}

provider "aws" {
  region  = "${var.region}"
  version = "~> 2.7"
}

data "aws_availability_zones" "available" {}

resource "aws_eip" "nateip" { // nat gateway elastic ip
  vpc = true

  tags = {
    Name        = "nat-eip"
    Environment = "main"
    Stack       = "nat"
  }
}