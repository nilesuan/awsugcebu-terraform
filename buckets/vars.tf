variable "region" {
  type    = "string"
  default = "ap-southeast-1"
}

provider "aws" {
  region  = "${var.region}"
  version = "~> 2.7"
}