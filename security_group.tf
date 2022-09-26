resource "aws_security_group" "example-lambda-vpc" {
  name   = "example-lambda-vpc-sg"
  vpc_id = aws_vpc.example-vpc.id

  ingress {
    from_port = 2049
    protocol  = "tcp"
    to_port   = 2049
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 2049
    protocol  = "tcp"
    to_port   = 2049
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "example-efs" {
  name   = "example-efs-sg"
  vpc_id = aws_vpc.example-vpc.id

  ingress {
    from_port       = 2049
    protocol        = "tcp"
    to_port         = 2049
    security_groups = [
      aws_security_group.example-lambda-vpc.id
    ]
  }
  ingress {
    from_port       = 2049
    protocol        = "udp"
    to_port         = 2049
    security_groups = [
      aws_security_group.example-lambda-vpc.id
    ]
  }
  egress {
    from_port   = 2049
    protocol    = "tcp"
    to_port     = 2049
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}
