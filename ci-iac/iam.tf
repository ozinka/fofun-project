resource "aws_iam_role" "ec2-fofun-iam-role" {
  name               = "ec2-fofun-iam-role"
  tags               = { Name = "ec2-fofun-iam-role" }
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "ec2_fofun_policy" {
  name        = "ec2_fofun_policy"
  path        = "/"
  description = "This policy provides full S3 access and SSM"
  policy = templatefile("conf/ec2_fofun_policy.json", {
    bucket = aws_s3_bucket.fofun-bucket.bucket
  })
}

resource "aws_iam_instance_profile" "fofun-ec2-iam-profile" {
  name = "fofun-ec2-iam-profile"
  role = aws_iam_role.ec2-fofun-iam-role.name
}

resource "aws_iam_role_policy_attachment" "fofun-policy-atch" {
  policy_arn = aws_iam_policy.ec2_fofun_policy.arn
  role       = aws_iam_role.ec2-fofun-iam-role.name
}