data "archive_file" "example-lambda-zip" {
  type        = "zip"
  source_dir  = "${path.module}/serverless"
  output_path = "${path.module}/lambda_dist/lambda.zip"
}

resource "aws_lambda_function" "example-lambda" {
  function_name    = "index"
  role             = aws_iam_role.example-lambda-role.arn
  timeout          = 60
  source_code_hash = data.archive_file.example-lambda-zip.output_base64sha256
  package_type     = "Image"
  image_uri        = "${aws_ecr_repository.example-ecr.repository_url}:latest"
  memory_size      = 256

  environment {
    variables = {
      HOST = "127.0.0.1"
    }
  }

  file_system_config {
    arn              = aws_efs_access_point.example-efs-access-point.arn
    local_mount_path = "/mnt/efs"
  }

  depends_on = [
    null_resource.example-ecr-container
  ]

  lifecycle {
    ignore_changes = [
      image_uri
    ]
  }

  vpc_config {
    security_group_ids = [
      aws_security_group.example-lambda-vpc.id
    ]
    subnet_ids = [
      aws_subnet.example-subnet-a.id
    ]
  }
}
