resource "aws_s3_bucket" "fofun-bucket" {
  bucket = "fofun"
  acl    = "private"

  tags = {
    Name = "fofun-storage"
  }
}