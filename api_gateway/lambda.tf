# Standard Lambda deployment
# Lambda ZIP > Upload > Create Role with assume + execution privileges > attach to Lambda

data "aws_iam_policy_document" "lambda_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"
  assume_role_policy = "${data.aws_iam_policy_document.lambda_assume_policy.json}"
}

data "aws_iam_policy_document" "lambda_execution_role_policy" {
  statement {
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "lambda_execution_role_policy" {
  policy = "${data.aws_iam_policy_document.lambda_execution_role_policy.json}"
}

resource "aws_iam_policy_attachment" "lambda_execution_role_attachment" {
  name = "lambda_execution_role_attachment"
  policy_arn = "${aws_iam_policy.lambda_execution_role_policy.arn}"
  roles = ["${aws_iam_role.lambda_execution_role.name}"]
}

data "archive_file" "lambda_archive" {
  type        = "zip"
  source_file = "${path.module}/files/callbackcode.py"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_lambda_function" "lambda_function" {
  filename = "${data.archive_file.lambda_archive.output_path }"

  function_name = "callbackcode"
  role = "${aws_iam_role.lambda_execution_role.arn}"

  handler = "callbackcode.handler"
  runtime = "python3.7"
}