data "template_file" "assume_role" {
  template = "${file("${path.module}/templates/assume_role.tpl")}"
}

data "template_file" "master" {
  template = "${file("${path.module}/templates/master_policy.tpl")}"
}

resource "aws_iam_role" "master" {
  name = "master"
  assume_role_policy = "${data.template_file.assume_role.rendered}"
}

resource "aws_iam_policy" "master" {
  policy = "${data.template_file.master.rendered}"
}

resource "aws_iam_role_policy_attachment" "master" {
  role = "${aws_iam_role.master.id}"
  policy_arn = "${aws_iam_policy.master.arn}"
}

data "template_file" "node" {
  template = "${file("${path.module}/templates/node_policy.tpl")}"
}

resource "aws_iam_role" "node" {
  name = "node"
  assume_role_policy = "${data.template_file.assume_role.rendered}"
}

resource "aws_iam_policy" "node" {
  policy = "${data.template_file.node.rendered}"
}

resource "aws_iam_role_policy_attachment" "node" {
  role = "${aws_iam_role.node.id}"
  policy_arn = "${aws_iam_policy.node.arn}"
}