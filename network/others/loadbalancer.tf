resource "aws_subnet" "loadbalancersubnet" {
  count                   = "${length(data.aws_availability_zones.available.names)}"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block              = "172.31.3${count.index}.0/24"
  vpc_id                  = "${aws_default_vpc.vpc.id}"

  tags = {
    Name        = "loadbalancer-subnet"
    Environment = "main"
    Stack       = "loadbalancer"
    AZ          = "${data.aws_availability_zones.available.names[count.index]}"
  }
}

resource "aws_route_table" "loadbalancerroutetable" {
  vpc_id = "${aws_default_vpc.vpc.id}"

  // route to internet gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags = {
    Name        = "loadbalancer-route-table"
    Environment = "main"
    Stack       = "loadbalancer"
  }
}

resource "aws_route_table_association" "loadbalancerroutetableassociation" {
  count          = "${length(data.aws_availability_zones.available.names)}"
  subnet_id      = "${element(aws_subnet.loadbalancersubnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.loadbalancerroutetable.id}"
}

resource "aws_network_acl" "loadbalancernetworkaccesscontrollist" {
  vpc_id     = "${aws_default_vpc.vpc.id}"
  subnet_ids = "${aws_subnet.loadbalancersubnet.*.id}"

  egress {
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
  }

  ingress {
    rule_no    = 101
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
    protocol   = "tcp"
  }

  ingress {
    rule_no    = 102
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
    protocol   = "tcp"
  }

  tags = {
    Name        = "loadbalancer-network-access-control-list"
    Environment = "main"
    Stack       = "loadbalancer"
  }
}