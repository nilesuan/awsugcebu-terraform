variable "region" {
  type    = "string"
  default = "ap-southeast-1"
}

provider "aws" {
  region  = "${var.region}"
  version = "~> 2.7"
}

data "aws_vpc" "cruvpc" {
  filter {
    name   = "tag:Name"
    values = ["cru-vpc"]
  }
}