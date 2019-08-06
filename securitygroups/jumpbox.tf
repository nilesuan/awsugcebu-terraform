resource "aws_security_group" "securitygroup" {
  name        = "${var.shortname}-security-group"
  description = "Allow http and ssh inbound traffic to  ${var.shortname}"
  vpc_id      = "${data.aws_vpc.vpc.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name       = "${var.shortname}-security-group"
    Environment = "administration"
    Stack      = "${var.shortname}"
  }
}