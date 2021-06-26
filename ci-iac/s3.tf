resource "aws_s3_bucket" "fofun_bucket" {
  bucket = "fofun"
  acl    = "private"

  tags = {
    Name = "fofun-storage"
  }
}