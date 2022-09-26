resource "aws_iam_role" "example-lambda-role" {
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole",
    "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientReadWriteAccess",
  ]
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
    },
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": "apigateway"
     }
  ]
}
EOF
}

resource "aws_iam_role" "example-api-gateway-invoke-role" {
  name               = "example-api-gateway-invoke-role"
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
      "Sid": "lambda"
    },
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": "apigateway"
     }
  ]
}
EOF
  inline_policy {
    name = "example-lambda-invoke-policy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["lambda:InvokeFunction"]
          Effect   = "Allow"
          Resource: "arn:aws:lambda:${var.aws_region}:${data.aws_caller_identity.example.account_id}:function:${aws_lambda_function.example-lambda.function_name}"
        },
      ]
    })
  }
}

resource "aws_iam_policy" "example-lambda-function-policy" {
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "lambda:InvokeFunction",
            "Resource": "arn:aws:lambda:${var.aws_region}:${data.aws_caller_identity.example.account_id}:function:${aws_lambda_function.example-lambda.function_name}"
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "example-lambda-invoke-policy-attach" {
  name       = "example-lambda-invoke-policy-attach"
  policy_arn = aws_iam_policy.example-lambda-function-policy.arn
  roles      = [
    aws_iam_role.example-api-gateway-invoke-role.name
  ]
}
