resource "aws_s3_bucket" "repo_storage" {
  bucket = "fofun"
  acl    = "private"

  tags = {
    Name = "fofun-storage"
  }
}