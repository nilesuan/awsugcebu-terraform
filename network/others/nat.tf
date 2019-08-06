// pick a random nat subnet
resource "random_integer" "natgatewaysubnet" {
  min = 0
  max = 2
}

resource "aws_nat_gateway" "natgateway" {
  allocation_id = "${aws_eip.nateip.id}"
  subnet_id     = "${element(aws_subnet.publicsubnet.*.id, random_integer.natgatewaysubnet.result)}"

  tags = {
    Name        = "nat-gateway"
    Environment = "main"
    Stack       = "nat"
  }
}