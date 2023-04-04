resource "aws_lambda_function" "test_lambda" {
  filename         = var.package
  function_name    = "${var.app_id}-${var.app_env}"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "index.handler"
  publish          = true
  source_code_hash = filesha256("${var.package}")
  timeout          = 20
  runtime          = "nodejs16.x"

  environment {
    variables = {
      foo = "bar"
    }
  }
  tags = {
    Project     = "demo-terraform"
    Owner       = "DevOps Team"
    Environment = "${var.app_env}"
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "${var.app_id}-${var.app_env}-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "policy" {
  name        = "${var.app_id}-${var.app_env}-policy"
  path        = "/"
  description = "My test policy"
  policy      = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
          {
              "Sid": "VisualEditor0",
              "Effect": "Allow",
              "Action": [
                  "dynamodb:PutItem",
                  "dynamodb:DeleteItem",
                  "dynamodb:GetItem",
                  "dynamodb:Scan",
                  "dynamodb:UpdateItem"
              ],
              "Resource": "arn:aws:dynamodb:us-east-1:*:table/*"
          },
          {
              "Sid": "VisualEditor1",
              "Effect": "Allow",
              "Action": [
                  "logs:CreateLogStream",
                  "logs:CreateLogGroup",
                  "logs:PutLogEvents"
              ],
              "Resource": "*"
          }
      ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.policy.arn
}

