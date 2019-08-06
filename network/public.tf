resource "aws_subnet" "publicsubnet" {
  count                   = "${length(data.aws_availability_zones.available.names)}"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block              = "172.31.1${count.index}.0/24"
  vpc_id                  = "${aws_default_vpc.vpc.id}"
  map_public_ip_on_launch = true

  tags = {
    Name        = "public-subnet"
    Environment = "main"
    Stack       = "public"
    AZ          = "${data.aws_availability_zones.available.names[count.index]}"
  }
}

resource "aws_route_table" "publicroutetable" {
  vpc_id = "${aws_default_vpc.vpc.id}"

  // route to internet gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags = {
    Name        = "public-route-table"
    Environment = "main"
    Stack       = "public"
  }
}

resource "aws_route_table_association" "publicroutetableassociation" {
  count          = "${length(data.aws_availability_zones.available.names)}"
  subnet_id      = "${element(aws_subnet.publicsubnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.publicroutetable.id}"
}

resource "aws_network_acl" "publicnetworkaccesscontrollist" {
  vpc_id     = "${aws_default_vpc.vpc.id}"
  subnet_ids = "${aws_subnet.publicsubnet.*.id}"

  egress {
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
  }

  ingress {
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
  }

  tags = {
    Name        = "public-network-access-control-list"
    Environment = "main"
    Stack       = "public"
  }
}