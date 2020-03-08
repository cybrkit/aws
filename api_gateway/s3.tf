# S3 Bucket for static pages, web hosting is not required as content is fetching through AWS API
resource "aws_s3_bucket" "frontend" {
  bucket_prefix = "frontend-"
  acl    = "private"
}

data "template_file" "idx" {
  template = "${file("${path.module}/templates/index.tpl")}"
  vars = {
    callback_url = "${aws_api_gateway_deployment.info.invoke_url}/info"
  }
}

# if content TYPE is omitted withh be octet stream
resource "aws_s3_bucket_object" "frontend_idx" {
  bucket = "${aws_s3_bucket.frontend.bucket}"
  key    = "index.html"
  content = "${data.template_file.idx.rendered}"
  content_type = "text/html"
}

data "template_file" "js" {
  template = "${file("${path.module}/templates/event_caller.tpl")}"
}

# if content TYPE is omitted withh be octet stream
resource "aws_s3_bucket_object" "frontend_js" {
  bucket = "${aws_s3_bucket.frontend.bucket}"
  key = "event_caller.js"
  content = "${data.template_file.js.rendered}"
  content_type = "text/javascript"
}