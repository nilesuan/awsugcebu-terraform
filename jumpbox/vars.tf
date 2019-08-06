variable "region" {
  type    = "string"
  default = "ap-southeast-1"
}

provider "aws" {
  region  = "${var.region}"
  version = "~> 2.7"
}

variable "shortname" {
  type    = "string"
  default = "jumpbox"
}

data "aws_availability_zones" "available" {}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["vpc"]
  }
}

data "aws_subnet_ids" "publicsubnet" {
  vpc_id = "${data.aws_vpc.vpc.id}"

  tags = {
    Name = "public-subnet"
  }
}

data "aws_subnet" "publicsubnet" {
  count = "${length(data.aws_subnet_ids.publicsubnet.ids)}"
  id    = "${data.aws_subnet_ids.publicsubnet.ids[count.index]}"
}

resource "aws_eip" "eip" {
  vpc = true

  tags = {
    Name        = "${var.shortname}-eip"
    Environment = "production"
    Stack       = "${var.shortname}"
  }
}

data "template_file" "userdata" {
  template = "${file("${path.module}/userdata.tpl")}"

  vars {
    eipallocationid = "${aws_eip.eip.id}"
    shortname = "${var.shortname}"
  }
}

data "aws_iam_role" "instancerole" {
  name = "eks-instance-role"
}