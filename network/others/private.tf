resource "aws_subnet" "privatesubnet" {
  count                   = "${length(data.aws_availability_zones.available.names)}"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block              = "172.31.2${count.index}.0/24"
  vpc_id                  = "${aws_default_vpc.vpc.id}"

  tags = {
    Name        = "private-subnet"
    Environment = "main"
    Stack       = "private"
    AZ          = "${data.aws_availability_zones.available.names[count.index]}"
  }
}

resource "aws_route_table" "privateroutetable" {
  vpc_id = "${aws_default_vpc.vpc.id}"

  // route to nat gateway
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.natgateway.id}"
  }

  tags = {
    Name        = "private-route-table"
    Environment = "main"
    Stack       = "private"
  }
}

resource "aws_route_table_association" "privateroutetableassociation" {
  count          = "${length(data.aws_availability_zones.available.names)}"
  subnet_id      = "${element(aws_subnet.privatesubnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.privateroutetable.id}"
}

resource "aws_network_acl" "privatenetworkaccesscontrollist" {
  vpc_id     = "${aws_default_vpc.vpc.id}"
  subnet_ids = "${aws_subnet.privatesubnet.*.id}"

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
    Name        = "private-network-access-control-list"
    Environment = "main"
    Stack       = "private"
  }
}