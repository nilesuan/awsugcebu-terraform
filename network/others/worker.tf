resource "aws_subnet" "workersubnet" {
  count                   = "${length(data.aws_availability_zones.available.names)}"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block              = "172.31.4${count.index}.0/24"
  vpc_id                  = "${aws_default_vpc.vpc.id}"

  tags = {
    Name        = "worker-subnet"
    Environment = "main"
    Stack       = "worker"
    AZ          = "${data.aws_availability_zones.available.names[count.index]}"
  }
}

resource "aws_route_table" "workerroutetable" {
  vpc_id = "${aws_default_vpc.vpc.id}"

  // route to nat gateway
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.natgateway.id}"
  }

  tags = {
    Name        = "worker-route-table"
    Environment = "production"
    Stack       = "worker"
  }
}

resource "aws_route_table_association" "workerroutetableassociation" {
  count          = "${length(data.aws_availability_zones.available.names)}"
  subnet_id      = "${element(aws_subnet.workersubnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.workerroutetable.id}"
}

resource "aws_network_acl" "workernetworkaccesscontrollist" {
  vpc_id     = "${aws_default_vpc.vpc.id}"
  subnet_ids = "${aws_subnet.workersubnet.*.id}"

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
    Name        = "worker-network-access-control-list"
    Environment = "production"
    Stack       = "worker"
  }
}
