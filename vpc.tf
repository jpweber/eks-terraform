#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Nat Gateway
#  * Route Table
#

resource "aws_vpc" "demo" {
  cidr_block = "${var.vpc-cidr-block}"

  tags = "${
    map(
     "Name", "terraform-eks-demo-node",
     "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_subnet" "demo-private" {
  vpc_id            = "${aws_vpc.demo.id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "${lookup(var.private-subnet-blocks, count.index)}"
  count             = "${var.num-private-subnets}"

  tags = "${
    map(
     "Name", "terraform-eks-demo-node",
     "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_subnet" "demo-public" {
  vpc_id            = "${aws_vpc.demo.id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "${lookup(var.public-subnet-blocks, count.index)}"
  count             = "${var.num-public-subnets}"

  tags = "${
    map(
     "Name", "terraform-eks-demo-node",
     "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"

  map_public_ip_on_launch = true

  # depends_on              = ["aws_route_table_association.demo-public"]
}

resource "aws_internet_gateway" "demo" {
  vpc_id = "${aws_vpc.demo.id}"

  tags {
    Name = "terraform-eks-demo"
  }
}

resource "aws_eip" "nat" {
  vpc = true

  count = "${var.num-private-subnets}"
}

resource "aws_nat_gateway" "demo" {
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.demo-public.*.id, count.index)}"

  count = "${var.num-private-subnets}"
}

resource "aws_route_table" "demo-public" {
  vpc_id = "${aws_vpc.demo.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.demo.id}"
  }
}

resource "aws_route_table" "demo-private" {
  vpc_id = "${aws_vpc.demo.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.demo.*.id, count.index)}"
  }
}

resource "aws_route_table_association" "demo-public" {
  count = "${var.num-public-subnets}"

  subnet_id      = "${element(aws_subnet.demo-public.*.id, count.index)}"
  route_table_id = "${aws_route_table.demo-public.id}"
}

resource "aws_route_table_association" "demo-private" {
  count = "${var.num-private-subnets}"

  subnet_id      = "${aws_subnet.demo-private.*.id[count.index]}"
  route_table_id = "${aws_route_table.demo-private.id}"
}
