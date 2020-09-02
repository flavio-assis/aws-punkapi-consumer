resource "aws_iam_role" "firehose_role" {
  name = var.firehose_role_name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "inline_firehole_policy" {
  name   = "FirehoseInlinePolicy"
  role   = aws_iam_role.firehose_role.id
  depends_on = [aws_iam_role.firehose_role]
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "s3:AbortMultipartUpload",
        "s3:GetBucketLocation",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:ListBucketMultipartUploads",
        "s3:PutObject"
      ],
      "Resource": [
        "${var.bucket_arn}",
        "${var.bucket_arn}/*"
      ]
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "kinesis:DescribeStream",
        "kinesis:GetShardIterator",
        "kinesis:GetRecords",
        "kinesis:ListShards"
      ],
      "Resource": "${var.kinesis_stream_arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role" "lambda_to_kinesis_stream" {
  name               = var.lambda_to_kinesis_stream_role_name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com",
          "kinesis.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "inline_lambda_policy" {
  name   = "LambdaInlinePolicy"
  role   = aws_iam_role.lambda_to_kinesis_stream.id
  depends_on = [aws_iam_role.lambda_to_kinesis_stream]
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "kinesis:PutRecords",
        "kinesis:PutRecord"
      ],
      "Resource": "${var.kinesis_stream_arn}"
    }
  ]
}
EOF
}
