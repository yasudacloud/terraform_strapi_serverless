resource "aws_ecr_repository" "example-ecr" {
  name                 = "example-lambda-image"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "null_resource" "example-ecr-container" {
  triggers = {
    lambda_hash = data.archive_file.example-lambda-zip.output_base64sha256
  }
  provisioner "local-exec" {
    command = "aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${aws_ecr_repository.example-ecr.repository_url}"
  }

  provisioner "local-exec" {
    command = "cd ./serverless && rm -rf .cache && rm -rf node_modules && npm install --arch=x64 --platform=linux sharp && npm run build"
  }

  provisioner "local-exec" {
    command = "docker build --no-cache --platform linux/x86_64 -t ${aws_ecr_repository.example-ecr.name} ./serverless"
  }

  provisioner "local-exec" {
    command = "docker tag ${aws_ecr_repository.example-ecr.name}:latest ${aws_ecr_repository.example-ecr.repository_url}"
  }

  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.example-ecr.repository_url}"
  }
}
