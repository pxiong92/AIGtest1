

resource "aws_s3_bucket" "test_bucket" {
  bucket = "my-tf-test-bucket-13478" #random id generator

  tags = {
    Name        = "Mys3_test_bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_policy" "allow_ssl_only" {
  bucket = aws_s3_bucket.test_bucket.id
  policy = data.aws_iam_policy_document.allow_ssl_requests_only.json
}

data "aws_iam_policy_document" "allow_ssl_requests_only" {
  statement {
    sid = "AllowSSLRequestsOnly"
    actions = [
      "s3:*",
    ]
    effect = "Deny"
    resources = [
      aws_s3_bucket.test_bucket.arn,
      "${aws_s3_bucket.test_bucket.arn}/*",
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
    principals {
      type        = "AWS"
      identifiers = ["*"] #check this
    }

  }
}
