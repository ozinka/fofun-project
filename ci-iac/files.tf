resource "aws_s3_bucket_object" "tc_file_ps1" {
  bucket = "fofun"
  key    = "conf/ps1.sh"
  source = "conf/ps1.sh"
  etag   = filemd5("conf/ps1.sh")
}