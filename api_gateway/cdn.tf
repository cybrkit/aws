# OAI required to access S3 Bucket - to be added to Bucket Policy
resource "aws_cloudfront_origin_access_identity" "cdn_oai" {
  comment = "frontend_s3_oai"
}

resource "aws_cloudfront_distribution" "frontend_cdn" {

  origin {
    domain_name = "${aws_s3_bucket.frontend.bucket_regional_domain_name}"
    origin_id   = "${aws_cloudfront_origin_access_identity.cdn_oai.id}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.cdn_oai.cloudfront_access_identity_path}"
    }
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${aws_cloudfront_origin_access_identity.cdn_oai.id}"

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

data "aws_iam_policy_document" "cdn_oai_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.frontend.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.cdn_oai.iam_arn}"]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = ["${aws_s3_bucket.frontend.arn}"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.cdn_oai.iam_arn}"]
    }
  }
}

resource "aws_s3_bucket_policy" "cdn_oai_policy_attachment" {
  bucket = "${aws_s3_bucket.frontend.id}"
  policy = "${data.aws_iam_policy_document.cdn_oai_policy.json}"
}