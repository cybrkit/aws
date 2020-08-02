data "template_file" "user_data" {
  template = "${file("${path.module}/templates/user_data.tpl")}"
}

resource "aws_security_group" "k8s_default" {
  name = "${var.k8s_name}.default"
  vpc_id = "${aws_vpc.k8s.id}"
}

resource "aws_security_group_rule" "inbound" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "ALL"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.k8s_default.id}"
}

resource "aws_security_group_rule" "outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "ALL"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.k8s_default.id}"
}

resource "aws_iam_instance_profile" "master" {
  name = "master"
  role = "${aws_iam_role.master.name}"
}

resource "aws_instance" "master" {
  ami = "${var.ami_id}"
  key_name = "${var.k8s_name}"
  instance_type = "t3.medium"
  subnet_id = "${aws_subnet.private.id}"
  iam_instance_profile = "${aws_iam_instance_profile.master.name}"
  user_data = "${base64encode(data.template_file.user_data.rendered)}"

  root_block_device {
    volume_size = 50
  }

  vpc_security_group_ids = ["${aws_security_group.k8s_default.id}"]

  tags = {
    Name = "${var.k8s_name}.master"
    "kubernetes.io/cluster/lab" = "lab"
  }
}

resource "aws_iam_instance_profile" "node" {
  name = "node"
  role = "${aws_iam_role.node.name}"
}

resource "aws_instance" "node" {
  count = 2
  ami = "${var.ami_id}"
  key_name = "${var.k8s_name}"
  instance_type = "t3.medium"
  subnet_id = "${aws_subnet.private.id}"
  iam_instance_profile = "${aws_iam_instance_profile.node.name}"
  user_data = "${base64encode(data.template_file.user_data.rendered)}"

  root_block_device {
    volume_size = 50
  }

  vpc_security_group_ids = ["${aws_security_group.k8s_default.id}"]

  tags = {
    Name = "${var.k8s_name}.node.${count.index}"
    "kubernetes.io/cluster/lab" = "lab"
  }
}

resource "aws_instance" "bastion" {
  ami = "${var.ami_id}"
  key_name = "${var.k8s_name}"
  instance_type = "t3.medium"
  subnet_id = "${aws_subnet.public.id}"
  associate_public_ip_address = true
  user_data = "${base64encode(data.template_file.user_data.rendered)}"
  vpc_security_group_ids = ["${aws_security_group.k8s_default.id}"]

  tags = {
    Name = "${var.k8s_name}.bastion"
  }
}