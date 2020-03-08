provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

# Simple API Gateway deployment with S3/CDN as frontend calling Lambda through API
module "api_gateway" {
  source = "./api_gateway"
  region = "${var.aws_region}"
}