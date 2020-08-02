resource "aws_vpc" "k8s" {
  cidr_block = "${var.k8s_cidr}"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.k8s_name}"
    "kubernetes.io/cluster/lab" = "lab"
  }
}

resource "aws_subnet" "public" {
  availability_zone_id = "${element(data.aws_availability_zones.region.zone_ids, 1)}"
  cidr_block = "${cidrsubnet(var.k8s_cidr, 8, 1)}"
  vpc_id = "${aws_vpc.k8s.id}"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.k8s_name}.public"
    "kubernetes.io/cluster/lab" = "lab"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.k8s.id}"
}

resource "aws_default_route_table" "public" {
  default_route_table_id = "${aws_vpc.k8s.default_route_table_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
}

resource "aws_eip" "ngw" {
  vpc = true
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = "${aws_eip.ngw.id}"
  subnet_id = "${aws_subnet.public.id}"
}

resource "aws_subnet" "private" {
  availability_zone_id = "${element(data.aws_availability_zones.region.zone_ids, 1)}"
  cidr_block = "${cidrsubnet(var.k8s_cidr, 8, 2)}"
  vpc_id = "${aws_vpc.k8s.id}"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.k8s_name}.private"
    "kubernetes.io/cluster/lab" = "lab"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.k8s.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.ngw.id}"
  }
}

resource "aws_route_table_association" "private" {
  route_table_id = "${aws_route_table.private.id}"
  subnet_id = "${aws_subnet.private.id}"
}