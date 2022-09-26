resource "aws_efs_file_system" "example-efs-filesystem" {
}

resource "aws_efs_mount_target" "example-efs-mount-target-a" {
  file_system_id  = aws_efs_file_system.example-efs-filesystem.id
  subnet_id       = aws_subnet.example-subnet-a.id
  security_groups = [
    aws_security_group.example-efs.id
  ]
}

resource "aws_efs_access_point" "example-efs-access-point" {
  file_system_id = aws_efs_file_system.example-efs-filesystem.id
  posix_user {
    gid = 1000
    uid = 1000
  }

  # Please set the appropriate value
  root_directory {
    path = "/volume"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = "0755"
    }
  }
}
