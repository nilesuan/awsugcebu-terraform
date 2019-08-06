resource "aws_subnet" "databasesubnet" {
  count                   = "${length(data.aws_availability_zones.available.names)}"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block              = "172.31.5${count.index}.0/24"
  vpc_id                  = "${aws_default_vpc.vpc.id}"

  tags = {
    Name        = "database-subnet"
    Environment = "production"
    Stack       = "database"
    AZ          = "${data.aws_availability_zones.available.names[count.index]}"
  }
}

resource "aws_route_table" "databaseroutetable" {
  vpc_id = "${aws_default_vpc.vpc.id}"

  // route to nat gateway
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.natgateway.id}"
  }

  tags = {
    Name        = "database-route-table"
    Environment = "production"
    Stack       = "database"
  }
}

resource "aws_route_table_association" "databaseroutetableassociation" {
  count          = "${length(data.aws_availability_zones.available.names)}"
  subnet_id      = "${element(aws_subnet.databasesubnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.databaseroutetable.id}"
}

resource "aws_network_acl" "databasenetworkaccesscontrollist" {
  vpc_id     = "${aws_default_vpc.vpc.id}"
  subnet_ids = "${aws_subnet.databasesubnet.*.id}"

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
    cidr_block = "172.31.0.0/16"
    from_port  = 3306
    to_port    = 3306
    protocol   = "tcp"
  }

  tags = {
    Name        = "database-network-access-control-list"
    Environment = "production"
    Stack       = "database"
  }
}

resource "aws_db_subnet_group" "databasesubnetgroup" {
  name       = "database-subnet-group"
  subnet_ids = "${aws_subnet.databasesubnet.*.id}"

  tags = {
    Name        = "database-subnet-group"
    Environment = "production"
    Stack       = "database"
  }
}