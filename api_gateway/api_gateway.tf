resource "aws_api_gateway_rest_api" "backend" {
  name = "backend_api_gateway"
}

resource "aws_api_gateway_resource" "backend" {
  rest_api_id = "${aws_api_gateway_rest_api.backend.id}"
  parent_id   = "${aws_api_gateway_rest_api.backend.root_resource_id}"
  path_part   = "info"
}

resource "aws_api_gateway_method" "info" {
  rest_api_id   = "${aws_api_gateway_rest_api.backend.id}"
  resource_id   = "${aws_api_gateway_resource.backend.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.backend.id}"
  resource_id             = "${aws_api_gateway_resource.backend.id}"
  http_method             = "${aws_api_gateway_method.info.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.lambda_function.invoke_arn}"
}

data "aws_caller_identity" "aws" {}
resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda_function.function_name}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.aws.account_id}:${aws_api_gateway_rest_api.backend.id}/*/${aws_api_gateway_method.info.http_method}${aws_api_gateway_resource.backend.path}"
}

resource "aws_api_gateway_deployment" "info" {
  rest_api_id = "${aws_api_gateway_rest_api.backend.id}"
  stage_name  = "test"

  # Second Deployment maybe needed for this since Terraform is failing first time.
  # This however, should be in CI/CD.
  depends_on = ["aws_api_gateway_method.info"]
}
